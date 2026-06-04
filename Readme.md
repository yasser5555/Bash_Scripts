# Bash Scripts Collection

A collection of Windows Batch scripts for automating daily development tasks, improving productivity, and simplifying repetitive workflows.

---

## 📌 About

This repository contains Batch `.bat` scripts that automate common tasks on Windows systems.

**Goals:**
- Automate repetitive developer tasks
- Build reusable command-line utilities
- Reduce human error in manual workflows
- Learn scripting through real-world examples

---

## 📂 Scripts

- [1. Create-mern-project.bat](#1-create-mern-projectbat)
- [2. Upload_to_Github.bat](#2-upload_to_githubbat)
- [3. Move_Files.bat](#3-move_filesbat)

---

## 1. Create-mern-project.bat

> Automates the creation of a complete full-stack MERN project structure.

Instead of manually creating folders, installing packages, and configuring React, Express, MySQL, and routing — this script does it all automatically in minutes.

### What Gets Generated

```
Project/
│
├── client/
│   └── src/
│       ├── app/
│       ├── pages/
│       ├── features/
│       ├── entities/
│       ├── widgets/
│       └── shared/
│
├── server/
│   └── src/
│       ├── config/
│       ├── middleware/
│       ├── utils/
│       ├── features/
│       └── shared/
│
├── Tools/
│   ├── Content.js
│   └── Report-Generator.js
│
├── Report/
├── package.json
└── README.md
```

---

### Execution Flow

#### Step 1 – Project Setup
- Prompts for a project name
- Validates that the name is not empty
- Creates the root project folder
- Generates a root `package.json` with the following scripts:

| Script | Action |
|---|---|
| `npm run client` | Runs React frontend only |
| `npm run server` | Runs Express backend only |
| `npm run dev` | Runs frontend and backend simultaneously |
| `npm run report` | Generates a Word progress report |

- Installs root dependencies: `concurrently`, `docx`

---

#### Step 2 – Backend Setup (`/server`)

**Initializes:**
- `npm init -y` inside `/server`

**Installs dependencies:**

| Package | Purpose |
|---|---|
| `express` | Build REST APIs |
| `mysql2` | Connect to MySQL databases |
| `dotenv` | Load environment variables from `.env` |
| `cors` | Allow cross-origin requests between frontend and backend |
| `express-session` | Manage user sessions |
| `express-mysql-session` | Store sessions in MySQL |
| `cookie-parser` | Read browser cookies |
| `nodemon` *(dev)* | Auto-restart server on file changes |

**Creates files:**
- `.env` — environment variables template
- `server.js` — Express entry point

**Creates folder structure:**

```
server/src/
├── config/        # Database and environment configuration
├── middleware/    # Auth, error handling middleware
├── utils/         # Reusable helper functions
├── features/      # Business logic modules (auth, users, products...)
└── shared/        # Common resources shared across features
```

---

#### Step 3 – Frontend Setup (`/client`)

**Creates React app via:**
```
npx create-react-app .
```

**Installs dependencies:**

| Package | Purpose |
|---|---|
| `react-router-dom` | Navigation, routing, protected routes |
| `bootstrap` | Ready-made UI components |
| `sass` | Advanced CSS with variables, mixins, nesting |

**Cleans up default React files:**
- Removes: `App.css`, `App.test.js`, `logo.svg`, `reportWebVitals.js`, `setupTests.js`

**Creates Feature-Sliced Design (FSD) architecture:**

```
client/src/
├── app/        # App-level config: routes, providers, layouts, store
├── pages/      # Full pages (Home, About, Dashboard...)
├── features/   # Business features (Login, Cart, Checkout...)
├── entities/   # Business entities (User, Product, Order...)
├── widgets/    # Complex UI blocks (Navbar, Sidebar, Footer...)
└── shared/     # Shared components, hooks, services, constants
```

**Auto-generates starter files:**

| File | Purpose |
|---|---|
| `App.js` | Application entry point, renders `<AppRoutes />` |
| `Layout.jsx` | Shared layout wrapper using `<Outlet />` |
| `Home.jsx` | Default home page component |
| `NotFound.jsx` | 404 page for unknown routes |
| `AppRoutes.jsx` | Full routing configuration with nested routes |

---

#### Step 4 – Report Generation System (`/Tools`)

One of the most useful features of this script.

**`Content.js`** — Data source for your reports. Fill in daily progress:
```js
addWhatIDid("Implemented Product Page");
addProblem("Database connection issue");
addNextStep("Test all API endpoints");
```

**`Report-Generator.js`** — Uses the `docx` package to auto-generate a `.docx` Word document.

**Generated report includes:**

```
Project Name
Date

What I Did
Current State
Problems
Next Steps
```

Reports are saved to:
```
Report/
└── Report-2026-06-04.docx
```

---

### Error Handling

If any installation step fails, the script stops immediately and displays:
```
ERROR: Something went wrong!
Check logs above.
```

---

### How to Use

1. Place `Create-mern-project.bat` in the folder where you want the project created
2. Double-click the `.bat` file
3. Enter your project name when prompted
4. Wait for the setup to complete
5. Run `npm run dev` to start development

---

## 2. Upload_to_Github.bat

> Automates the full Git upload workflow through an interactive interface.

Instead of typing multiple Git commands manually, this script guides you step by step.

### What It Does

- Verifies Git is installed before proceeding
- Initializes a local Git repository (if not already initialized)
- Checks for and configures the remote `origin`
- Stages files (all or selected)
- Creates a commit with your message
- Pushes to your specified branch

---

### Execution Flow

#### Step 1 – Startup
- Displays a welcome banner
- Verifies Git installation via `git --version`
- If Git is missing, shows an error and exits safely

#### Step 2 – User Inputs

| Prompt | Example Input |
|---|---|
| GitHub repository URL | `https://github.com/username/project.git` |
| Commit message | `Initial project upload` |
| Branch name | `main` (defaults to `main` if left empty) |
| Is the repository empty? | `y` or `n` |

> ⚠️ If the repository is **not empty**, a warning is displayed about potential merge conflicts.

#### Step 3 – Choose Upload Mode

```
[1] Upload all files
[2] Upload specific files only
```

**Mode 1 — Upload All:**
```
git add .
```

**Mode 2 — Upload Selected:**
- Lists all files in the directory via `dir /b`
- Prompts for filenames separated by spaces
- Validates each file exists before staging
- Stages only the chosen files

#### Step 4 – Commit and Push
```
git commit -m "your message"
git push -u origin main
```

Displays `Upload completed successfully!` when done.

---

### How to Use

1. Place `Upload_to_Github.bat` inside your project folder
2. Double-click the script
3. Enter the repository URL, commit message, and branch name
4. Choose whether to upload all files or specific ones
5. Wait for the push to complete
6. Verify the files on GitHub

---

## 3. Move_Files.bat

> Automatically organizes files by extension into a specified folder.

Keeps your working directory clean without manual sorting.

### What It Does

- Prompts for a file extension (e.g. `txt`, `pdf`, `jpg`)
- Prompts for a destination folder name
- Creates the folder automatically if it doesn't exist
- Moves all matching files into the folder
- Reports which files were moved
- Notifies you if no matching files were found

---

### Execution Flow

#### Step 1 – User Inputs

| Prompt | Example |
|---|---|
| File extension | `txt` |
| Destination folder | `Documents` |

#### Step 2 – Folder Check
- If folder exists → uses it as-is
- If folder does not exist → creates it automatically

#### Step 3 – File Processing
- Searches for all files matching `*.ext` in the current directory
- Moves each matching file into the destination folder
- Prints the name of each moved file
- If no files are found, displays: `No .ext files found.`

---

### Example

**Before:**
```
Project/
├── notes.txt
├── report.txt
├── image.jpg
└── Move_Files.bat
```

**Input:** extension = `txt`, folder = `Documents`

**After:**
```
Project/
├── image.jpg
├── Move_Files.bat
└── Documents/
    ├── notes.txt
    └── report.txt
```

**Output:**
```
Folder "Documents" created.
Moved: notes.txt
Moved: report.txt
Done.
```

---

### How to Use

1. Place `Move_Files.bat` in the folder containing the files to organize
2. Double-click the script
3. Enter the file extension to filter by
4. Enter the destination folder name
5. Review the output and verify files were moved

---

## ⚡ Getting Started

```bash
# Clone the repository
git clone https://github.com/yasser5555/Bash_Scripts.git

# Navigate into the folder
cd Bash_Scripts
```

To run any script, simply **double-click** the `.bat` file or run it from the Command Prompt:
```
script.bat
```

---

## 🛠 Requirements

- Windows OS
- Windows CMD
- Git (for `Upload_to_Github.bat`)
- Node.js & npm (for `Create-mern-project.bat`)

---

## 🤝 Contributions

Contributions are welcome!

1. Fork the repository
2. Create a new branch
3. Commit your changes
4. Open a Pull Request

---

## 📜 License

This project is open-source and available under the **MIT License**.

---

## 👨‍💻 Author

Created by [Mohamed Yasser](https://github.com/yasser5555)