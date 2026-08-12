# Async-FIFO-AXI

This project implements an asynchronous FIFO with an outer AXI module. 

An overview of the challenges and solutions that were addressed:
-⚠️ Crossing Clock Domains (CDC)
  -✅  Used two flip flop synchronizers to cross pointer signals between clock domains and prevent metastability
  -✅  Used Gray-coded pointers to safely transfer FIFO state
-⚠️ Full/Empty detection
  -✅  Used local and gray pointers to compare to empty + full conditions
-⚠️ AXI Integration
  -✅  Created an AXI wrapper to interface with the standard handshaking protocol
-⚠️ Verification
  -✅  Created test benches to verify FIFO operation under conditions of full, empty, reading, and writing
  
