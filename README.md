# Library Management System (IBM i Training Project)

![Architecture Diagram](architecture.png)

## Project Overview
The Library Management System is a specialized inventory and membership tracking application built on the IBM i (AS/400) platform. It provides a robust framework for managing book circulation, inventory levels, and member activity using industrial-grade database and programming patterns.

## Thought Process and Design Choices
This training project was designed to demonstrate core AS/400 business computing concepts, emphasizing data normalization and logic-driven record updates.

1. **Relational Data Modeling**: Instead of a flat-file approach, the system uses relational Physical Files (PF). By separating `BOOKS` from `MEMBERS` and linking them through circulation logic, the system scales better and avoids redundant data storage.
2. **Business Rule Enforcement**: The circulation engine is built to enforce rules strictly. For instance, a book cannot be issued if its status is 'Out' or if the member attempting the checkout is marked 'Inactive'. This logic is centralized in the RPGLE program to ensure consistency across the application.
3. **Control Language Driver (CLLE)**: A CLLE program acts as the entry point, automating environment setup tasks such as library list management. This mirrors real-world production setups where users launch applications through job-level control scripts.

## How It Works
- **Database Architecture**: 
  - **BOOKS PF**: Tracks each book's title, author, and current availability status.
  - **MEMBERS PF**: Maintains user records and membership validation fields.
- **Circulation Logic (RPGLE)**: When a librarian issues or returns a book, the RPGLE engine performs the following:
  - Validates the member's ID against the `MEMBERS` file.
  - Checks if the requested book exists and is available.
  - Atomically updates the `BOOKS` record to reflect the new inventory count and status.
- **User Interface**: The system utilizes Screen Design Aid (SDA) to create interactive displays for managing inventory and generating membership reports.

## Deployment Instructions on IBM i (AS/400)

Follow these steps to deploy and run the system on your AS/400 machine:

### 1. Environment Setup
Create a development library and source physical files:
```sql
CRTLIB LIB(LIBRARYLIB)
CRTSRCPF FILE(LIBRARYLIB/QDDSSRC) RCDLEN(112)
CRTSRCPF FILE(LIBRARYLIB/QRPGLESRC) RCDLEN(112)
CRTSRCPF FILE(LIBRARYLIB/QCLSRC) RCDLEN(112)
```

### 2. Upload and Copy Source
Ensure the source files from this repository are placed into their respective source file members in `LIBRARYLIB`. Use FTP or IBM i Access Client Solutions for file transfer.

### 3. Compilation Order
Compile the objects in the following sequence to ensure all references are correctly resolved:

1. **Database Objects**:
   ```sql
   CRTPF FILE(LIBRARYLIB/BOOKS) SRCFILE(LIBRARYLIB/QDDSSRC)
   CRTPF FILE(LIBRARYLIB/MEMBERS) SRCFILE(LIBRARYLIB/QDDSSRC)
   ```
2. **Logic Engine (RPGLE)**:
   ```sql
   CRTBNDRPG PGM(LIBRARYLIB/BOOK_CIRC) SRCFILE(LIBRARYLIB/QRPGLESRC)
   ```
3. **Initial Program (CLLE)**:
   ```sql
   CRTBNDCL PGM(LIBRARYLIB/INIT_PGM) SRCFILE(LIBRARYLIB/QCLSRC)
   ```

### 4. Running the Application
To launch the system and start the circulation menu, execute the driver program:
```sql
CALL PGM(LIBRARYLIB/INIT_PGM)
```

---
*Developed as part of the IBM i & Data Projects Portfolio.*
