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

require('lanes')
require('is')

--TODO add a neuron_t class that handles setting its own listeners and routing
--its own messages.
--
--Thursday, I discovered that the thundering herd must either not consume from
--the linda with :get() or :receive() and consume the stimulus.  This means
--that I'm going to have to address each neuron separately.  Each one will have
--its own linda and will :receive() and consume each stimulus.  Sending a
--stimulus will therefore involve iterating through a list of lindas and
--sending the same stimulus to each one.
--
-- output_1-------output_2
--    linda_o1  /    linda_o2
--    |       /
-- hidden_1
--    linda_h1

neural_net_t = {}

setmetatable(neural_net_t, neural_net_t)

tests = {}

function tests.__call()
   local nn = neural_net_t{
      hidden_layer = {
         num_neurons = 2,
         num_inputs_per_neuron = 3,
      },
      output_layer = {
         num_neurons = 1
      }
   }
   assert(is.a(neural_net_t, nn))
   nn:shutdown()
end
function neural_net_t:__call(attr)
   is.table_or_bail(attr)
   is.table_or_bail(attr.hidden_layer)
   is.number_or_bail(attr.hidden_layer.num_neurons)
   is.number_or_bail(attr.hidden_layer.num_inputs_per_neuron)
   is.table_or_bail(attr.output_layer)
   is.number_or_bail(attr.output_layer.num_neurons)

   local function neuron_generator(
      name,
      input_address,
      output_address,
      through_address,
      num_inputs,
      input_linda,
      output_linda
   )
      is.string_or_bail(name)
      is.string_or_bail(input_address)
      is.string_or_bail(output_address)
      is.number_or_bail(num_inputs)
      is.userdata_or_bail(input_linda)
      is.userdata_or_bail(output_linda)
      return function ()
         local num_received = 0
         local received = {insert = table.insert}
         local weights = {}
         local bias_index = 0
         for i=1,num_inputs+1 do
            weights[i] = math.random()
            bias_index = i
         end
         while true do
            while num_received < num_inputs do
               local input = input_linda:get(input_address)
print(name .. ' received ' .. tostring(input))
               received:insert(input)
               num_received = num_received + 1
            end
            local sum = 0
            for i,val in ipairs(received) do
               sum = sum + weights[i] * val
            end
            sum = sum - weights[bias_index]
            output_linda:send(output_address, sum)
            num_received = 0
            received = {insert = table.insert}
            collect_garbage()
            --TODO listen on correction_address and adjust weights accordingly
         end
      end
   end

   local o = {
      shutdown = neural_net_t.shutdown,
      stimulate = neural_net_t.stimulate,
      _ = {
         hidden = {
            input_linda = lanes.linda(),
            input_names = {insert = table.insert},
            neurons = {insert = table.insert},
            num_inputs = attr.hidden_layer.num_inputs_per_neuron,
            num_neurons = attr.hidden_layer.num_neurons,
            output_address = 'o_in',
            output_linda = nil, -- set to output layer's input linda later
            output_names = {insert = table.insert}
         },
         output = {
            input_linda = lanes.linda(),
            input_names = {insert = table.insert},
            neurons = {insert = table.insert},
            num_inputs = attr.hidden_layer.num_neurons,
            num_neurons = attr.output_layer.num_neurons,
            output_address = 'o_out',
            output_linda = lanes.linda(),
            output_names = {insert = table.insert}
         },
      },
   }
   o._.hidden.output_linda = o._.output.input_linda

   for layer_name,layer_attrs in pairs(o._) do
      for i=1,layer_attrs.num_neurons do
         local neurons = layer_attrs.neurons
         -- create the neuron, launch, and store its handle
         neurons:insert(
            lanes.gen('*',
               neuron_generator(
                  layer_name .. tostring(i),
                  layer_attrs.input_address,
                  layer_attrs.output_address,
                  layer_attrs.num_inputs,
                  layer_attrs.input_linda,
                  layer_attrs.output_linda
               )
            )()
         )
      end
   end

   setmetatable(o, neural_net_t)

   return o
end

function neural_net_t:shutdown()
   -- TODO add functionality to return a table representing the final weights
   for layer_name,layer_attrs in pairs(self._) do
      for _,neuron in ipairs(layer_attrs.neurons) do
         neuron:cancel()
      end
   end
end

function tests.stimulate()
   local nn = neural_net_t{
      hidden_layer = {
         num_neurons = 2,
         num_inputs_per_neuron = 3,
      },
      output_layer = {
         num_neurons = 1
      }
   }
   nn:stimulate(1)
while true do end
   nn:shutdown()
end
function neural_net_t:stimulate(num)
   is.number_or_bail(num)
print('sending ' .. tostring(num) .. ' on ' .. self._.hidden.input_address)
   self._.hidden.input_linda:send(
      self._.hidden.input_address,
      num
   )
end

if arg and arg[0]:match('.*neural_net_t.lua') then
   for name,unittest in pairs(tests) do
      io.write(name)
      io.write(': ')
      io.flush()
      unittest()
      io.write('passed\n')
   end
end

module('neural_net_t')
