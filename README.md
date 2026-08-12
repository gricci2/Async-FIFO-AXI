# Async-FIFO-AXI

This project implements an asynchronous FIFO with an outer AXI module. 

An overview of the challenges and solutions that were addressed:
- **Clock Domain Crossing**<br>
  - Used two flip flop synchronizers to cross pointer signals between clock domains and prevent metastability
  - Used Gray-coded pointers to safely transfer FIFO state
- **Full/Empty detection**<br>
  - Used local and gray pointers to compare to empty + full conditions
- **AXI Integration**<br>
  - Created an AXI wrapper to interface with the standard handshaking protocol
- **Verification**<br>
  - Created test benches to verify FIFO operation under conditions of full, empty, reading, and writing
  
