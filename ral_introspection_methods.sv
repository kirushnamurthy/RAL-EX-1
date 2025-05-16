// introspection methods 

class ral_introspection_seq extends uvm_reg_sequence;

  `uvm_object_utils(ral_introspection_seq)

  function new(string name = "ral_introspection_seq");
    super.new(name);
  endfunction

  virtual task body();
    my_block blk;
    STATUS_REG reg;
    uvm_reg_field fields[$];
    uvm_reg regs[$];
    uvm_reg_block blocks[$];
    uvm_reg_map maps[$];
    string name, full_name, access;
    uvm_reg_addr_t addr;
    uvm_reg_data_t val;
    bit has_reset;

    blk = my_block::type_id::create("blk");
    blk.build();
    blk.lock_model();

    reg = blk.status_reg; // status_reg is a register .(uvm_reg)

    // --- Introspection starts here ---
    name       = reg.get_name();
    full_name  = reg.get_full_name();
    access     = reg.get_access();
    reg.get_address(addr);
    has_reset  = reg.has_reset();
    val        = reg.get_mirrored_value();

    `uvm_info("RAL_INTROSPECTION", $sformatf("Name: %s", name), UVM_MEDIUM)
    `uvm_info("RAL_INTROSPECTION", $sformatf("Full Name: %s", full_name), UVM_MEDIUM)
    `uvm_info("RAL_INTROSPECTION", $sformatf("Access: %s", access), UVM_MEDIUM)
    `uvm_info("RAL_INTROSPECTION", $sformatf("Address: 0x%0h", addr), UVM_MEDIUM)
    `uvm_info("RAL_INTROSPECTION", $sformatf("Has Reset: %0d", has_reset), UVM_MEDIUM)
    `uvm_info("RAL_INTROSPECTION", $sformatf("Mirrored Value: 0x%0h", val), UVM_MEDIUM)

    // Fields
    reg.get_fields(fields);
    foreach(fields[i]) begin
      `uvm_info("RAL_FIELD", $sformatf("Field: %s, LSB: %0d, Access: %s, Width: %0d",
        fields[i].get_name(),
        fields[i].get_lsb_pos(),
        fields[i].get_access(),
        fields[i].get_n_bits()), UVM_MEDIUM)

      if (fields[i].has_reset())
        `uvm_info("RAL_FIELD", $sformatf("Reset: 0x%0h", fields[i].get_reset()), UVM_MEDIUM)
    end

    // Blocks
    blk.get_blocks(blocks);
    foreach(blocks[i]) begin
      `uvm_info("RAL_BLOCK", $sformatf("Block: %s", blocks[i].get_name()), UVM_MEDIUM)
    end

    // Registers
    blk.get_registers(regs, 1);
    foreach(regs[i]) begin
      `uvm_info("RAL_REG", $sformatf("Register: %s", regs[i].get_name()), UVM_MEDIUM)
    end

    // Maps
    blk.get_maps(maps);
    foreach(maps[i]) begin
      `uvm_info("RAL_MAP", $sformatf("Map: %s", maps[i].get_name()), UVM_MEDIUM)
    end
  endtask
endclass
      
OUTPUT :
      
UVM_INFO RAL_INTROSPECTION - Name: STATUS_REG
UVM_INFO RAL_INTROSPECTION - Full Name: blk.STATUS_REG
UVM_INFO RAL_INTROSPECTION - Access: RW
UVM_INFO RAL_INTROSPECTION - Address: 0x0
UVM_INFO RAL_INTROSPECTION - Has Reset: 1
UVM_INFO RAL_INTROSPECTION - Mirrored Value: 0x00000000
UVM_INFO RAL_FIELD - Field: READY, LSB: 0, Access: RW, Width: 1
UVM_INFO RAL_FIELD - Reset: 0x0
UVM_INFO RAL_FIELD - Field: ERROR, LSB: 1, Access: RO, Width: 1
UVM_INFO RAL_FIELD - Reset: 0x0
UVM_INFO RAL_BLOCK - Block: my_block
UVM_INFO RAL_REG - Register: STATUS_REG
UVM_INFO RAL_MAP - Map: default_map

      
