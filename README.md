# Windows 11 GPU Optimization and Virtual Memory Configuration Script

## Overview

This PowerShell script optimizes GPU preferences for various applications and configures virtual memory settings on Windows 11. The script:

- Sets GPU preference to **High Performance** for supported apps (browsers, Adobe Photoshop, Microsoft Office, etc.).
- Adjusts virtual memory (pagefile) to optimize system performance.
- Ensures registry values are correctly set.

## Features

- **GPU Optimization:** Forces selected applications to use high-performance GPU.
- **Virtual Memory Configuration:** Sets the initial and maximum size of the pagefile.
- **Windows 11 Compatibility:** Works on Windows 11 with administrator privileges.

## Prerequisites

Before running the script:

- Ensure you have **administrator privileges**.
- Enable PowerShell script execution if required.

## Installation

Clone the repository to your local machine:

```sh
git clone https://github.com/yourusername/windows11-gpu-script.git
cd windows11-gpu-script
```

## How to Run the Script

### 1️⃣ Enable PowerShell Script Execution

By default, Windows restricts script execution. To enable it:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

### 2️⃣ Run the Script

1. Open **PowerShell as Administrator**.
2. Navigate to the script folder:
   ```powershell
   cd "C:\Path\To\Script\"
   ```
3. Execute the script:
   ```powershell
   .\Windows11GPUConfig.ps1
   ```

### 3️⃣ Restart Your Computer

- A restart is **required** to apply GPU and virtual memory settings.

## Customization

Modify the script to add/remove applications for GPU optimization:

- Edit the `Set-GpuPreference` function to include additional apps.
- Change the **virtual memory size** in the `Set-VirtualMemory` function.

## Troubleshooting

- **Error: Script is blocked by execution policy**
  ```powershell
  Set-ExecutionPolicy Unrestricted -Scope Process
  ```
- **Error: Cannot find application path**
  - Ensure the correct path is specified in the script for each application.
- **Changes not applying?**
  - Restart the PC after running the script.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to open issues or submit pull requests to improve the script!

---

**Author:** Javian Picardo\
**LinkedIn:** [javianpicardo](https://linkedin.com/in/javianpicardo)

