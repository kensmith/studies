#pragma once

/**
  * See the paper hosted here.
  *
  * http://yogiken.wordpress.com/2010/02/10/on-publishing/
  *
  * This is a general purpose mechanism for safely accessing
  * MMIO register fields. Safe means that it is a compile
  * time error to write to a read-only field or read from a
  * write-only field, for eg. It increases readability of
  * register access while preserving low level performance
  * when generating optimized code.  Note, without
  * optimization, the compiler will generate function calls
  * for the static functions and performance will be
  * significantly worse than other register access idioms.
  * With performance turned on, the statics are inlined away
  * and performance is on par with other industry standard
  * register access techniques.
 */
namespace reg
{
   /**
    * Access an individual field within an MMIO register.
    * @param address the numerical address of the register
    * @param mask the width of the field as a contiguous mask of
    * 1s.
    * @param offset number of times to left shift to get to
    * the LSB of the field
    * @param a class which implements read, write or both
    * which performs the actual action
    */
   template
   <
      unsigned address,
      unsigned mask,
      unsigned offset,
      class mutability_policy
   >
   struct field_t
   {
      /**
       * Write to a register field.
       * @param[in] value the naturally aligned value
       */
      static void write(unsigned value)
      {
         mutability_policy::write(
            reinterpret_cast<volatile unsigned *>(address),
            mask,
            offset,
            value
         );
      }

      /**
       * Read from a register field.
       * @return the field as a naturally aligned value
       */
      static unsigned read()
      {
         return mutability_policy::read(
            reinterpret_cast<volatile unsigned *>(address),
            mask,
            offset
         );
      }
   };

   namespace policy
   {
      /**
       * Write-only mutability policy
       */
      struct wo_t
      {
         /**
          * Write to a field, writing zeroes to the other fields
          * without regard to their present contents.
          * @param[in] reg the address of the register
          * @param[in] mask the width of the field defined as a
          * bit mask.
          * @param[in] offset number of bits to shift left to get
          * to the LSB of the field
          * @param[in] the new value for the field, naturally
          * aligned
          */
         static void write(
            volatile unsigned* reg,
            unsigned mask,
            unsigned offset,
            unsigned value
         )
         {
            *reg = (value & mask) << offset;
         }
      };

      /**
       * Read-only mutability policy
       */
      struct ro_t
      {
         /**
          * Read the value of a field.
          * @param[in] reg the address of the register
          * @param[in] mask the width of the field defined as a
          * bit mask.
          * @param[in] offset number of bits to shift left to get
          * to the LSB of the field
          * @return the present value of the field, naturally
          * aligned
          */
         static unsigned read(
            volatile unsigned* reg,
            unsigned mask,
            unsigned offset
         )
         {
            return (*reg >> offset) & mask;
         }
      };

      /**
       * Read-write mutability policy
       */
      struct rw_t : ro_t
      {
         /**
          * Use read-modify-write to change only the value of the
          * field, preserving the rest of the register's contents.
          * @param[in] reg the address of the register
          * @param[in] mask the width of the field defined as a
          * bit mask.
          * @param[in] offset number of bits to shift left to get
          * to the LSB of the field
          * @param[in] value te new value of the field, naturally
          * aligned
          */
         static void write(
            volatile unsigned* reg,
            unsigned mask,
            unsigned offset,
            unsigned value
         )
         {
            *reg =
               (*reg & ~(mask << offset))
               |
               ((value & mask) << offset);
         }
      };
   }
}
