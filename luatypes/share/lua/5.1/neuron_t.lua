--[[

Copyright (c) 2009, Ken Smith kgsmith gmail
All rights reserved.

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the following
conditions are met:

  • Redistributions of source code must retain the above
    copyright notice, this list of conditions and the
    following disclaimer.
  • Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the
    following disclaimer in the documentation and/or other
    materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--]]

require('is')
require('lanes')
require('posix')

math.randomseed(os.time())

neuron_t = {}

setmetatable(neuron_t, neuron_t)

tests = {}

function tests.__call()
   local linda = lanes.linda()
   local a = neuron_t('test', 3, linda)
   assert(is.a(neuron_t, a))
end
---Instantiate a neuron_t.
function neuron_t:__call(name, num_inputs, hidden, output_linda, output_address, through_linda)
   is.string_or_bail(name)
   is.number_or_bail(num_inputs)
   is.boolean_or_bail(hidden)
   is.userdata_or_bail(output_linda)
   is.number_or_bail(output_address)
   assert(type(through_linda) == 'nil' or type(through_linda) == 'userdata')

   local o = {
      _ = {
         name = name,
         num_inputs = num_inputs,
         hidden = hidden,
         weights = {},
         bias_index = 0,
         input_linda = lanes.linda(),
         output_linda = output_linda,
         output_address = output_address,
         through_linda = through_linda,
         learning_rate = 0.25,
      },
      on = neuron_t.on,
      stim = neuron_t.stim,
      off = neuron_t.off,
      linda = neuron_t.linda,
      status = neuron_t.status,
      result = neuron_t.result,
   }

   for i=1,o._.num_inputs+1 do
      o._.weights[i] = math.random()*2-1 -- [-1,1]
      o._.weights[i] = o._.weights[i]/10 -- [-0.1,0.1]
      o._.bias_index = i -- ends up equivalent to #o._.weights
   end

   setmetatable(o, neuron_t)

   o:on()

   return o
end

function tests.linda()
   local linda = lanes.linda()
   local a = neuron_t('test', 3, linda)
   assert(type(a:linda()) == 'userdata')
end
---Get the input linda for this neuron_t.
function neuron_t:linda()
   return self._.input_linda
end

function neuron_t:status()
   return self._.lane.status
end

function tests.on()
   local linda = lanes.linda()
   local a = neuron_t('test', 3, linda)
   a:on()
   while a:status() == 'pending' do
      io.write('.') io.flush()
   end
   assert(a:status() == 'running', a:status())
   a:off()
end
---Start the neuron_t's run loop.
function neuron_t:on()
   self._.lane = lanes.gen('*',
      function ()
         require('helpers')
         while true do
            -- read and optionally forward all input signals
            local num_received = 0
            local received = {}
            collectgarbage()
            while num_received < self._.num_inputs do
               for i=1,self._.num_inputs do
                  local input = self._.input_linda:receive(nil, i)
                  received[i] = input
                  if self._.through_linda then
                     self._.through_linda:send(nil, i, input)
                  end
                  num_received = num_received + 1
               end
            end

            -- react
            local activation = 0
            for i=1,self._.num_inputs do
               activation = activation + self._.weights[i] * received[i]
            end
            activation = activation + self._.weights[self._.bias_index] * 1
            local output = 1/(1+math.exp(-activation)) -- sigmoid in [0,1]
            self._.output_linda:send(nil, self._.output_address, output)
            local output_prime = output * (1 - output) -- first deriv of sigmoid

            -- refine
            local correct = self._.output_linda:receive(nil, -1)
            local wrongness = correct - output
            if self._.hidden then
               wrongness = correct
            end
            for i=1,self._.num_inputs+1 do
               local correction_factor = wrongness * output_prime
               local received_or_bias = 1
               if i ~= self._.bias_index then
                  received_or_bias = received[i]
                  self._.input_linda:send(nil, -i, correction_factor * self._.weights[i])
               end
               local correction =
                  correction_factor * self._.learning_rate * received_or_bias
               self._.weights[i] = self._.weights[i] + correction
            end
         end
      end
   )()
end

function tests.off()
   local linda = lanes.linda()
   local a = neuron_t('test', 3, linda)
   a:on()
   a:off()
   while a._.lane.status == 'pending' or a._.lane.status == 'running' do
      io.write('.') io.flush()
   end
   assert(a._.lane.status == 'cancelled',a._.lane.status)
end
---Stop a neuron_t's run loop.
function neuron_t:off()
   if self._.lane then
      self._.lane:cancel()
   end
end

function neuron_t:result(expected_result)
   local result = self._.output_linda:receive(nil, self._.output_address)
   self._.output_linda:send(nil, -self._.output_address, expected_result or result)
   return result
end

function tests.stim()
   local linda = lanes.linda()
   local a = neuron_t('test', 3, linda)
   a:on()
   a:stim(1, 1)
   a:stim(2, 2)
   a:stim(3, 3)
   local output = linda:receive('yo')
   assert(
      type(output) == 'number' and -(1+2+3) <= output and output <= (1+2+3),
      'output = "' .. tostring(output) .. '"'
   )
   a:off()
end
---Send a stimulus to a neuron_t.
function neuron_t:stim(i, val)
   is.number_or_bail(i)
   is.number_or_bail(val)
   local status = self:status()
   assert(status == 'running' or status == 'pending', 'status=' .. status)
   return self._.input_linda:send(nil, i, val)
end

function tests.or_test()
   local linda = lanes.linda()
   local a = neuron_t('or gate', 2, false, linda, 1)
   local noisy = false
   local result

   for i=1,66 do
      if noisy then
         print('\ni = ' .. tostring(i))
      end

      a:stim(1, 1)
      a:stim(2, 1)
      result = a:result(1)

      if noisy then
         print('result(1,1): ' .. tostring(result))
      end

      a:stim(1, 1)
      a:stim(2, 0)
      result = a:result(1)
      if noisy then
         print('result(1,0): ' .. tostring(result))
      end

      a:stim(1, 0)
      a:stim(2, 1)
      result = a:result(1)
      if noisy then
         print('result(0,1): ' .. tostring(result))
      end

      a:stim(1, 0)
      a:stim(2, 0)
      result = a:result(0)
      if noisy then
         print('result(0,0): ' .. tostring(result))
      end
   end

   a:off()
end

function tests.four_way_and_with_hidden_gates()
   local linda = lanes.linda()
   local a = neuron_t('and gate', 2, false, linda, 1)
   local c = neuron_t('hidden gate 2', 2, true, a:linda(), 2)
   local b = neuron_t('hidden gate 1', 2, true, a:linda(), 1, c:linda())

   local result
   local noisy = true
   for i=1,66 do
      print('\ni = ' .. tostring(i))
      b:stim(1, 0)
      b:stim(2, 0)
      c:stim(1, 0)
      c:stim(2, 0)
      result = a:result(0)
      if noisy then
         print('result(0,0): ' .. tostring(result))
      end
   end

   a:off() b:off() c:off()
end

if arg and arg[0]:match('.*neuron_t.lua') then
   for name,unittest in pairs(tests) do
if name == 'four_way_and_with_hidden_gates' then
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
end
   end
end

module('neuron_t')
