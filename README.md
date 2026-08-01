# Device-Free Spatial Measurement Engine (Project: Room Scanner)
## Project Architecture and Implementation Document

### 1. Executive Summary & Features Analysis

**Project Vision**
The "Device-Free Spatial Measurement Engine" (internally referenced as Project Room Scanner) aims to democratize spatial mapping and measurement by leveraging standard smartphone hardware. Our goal is to provide a robust, scalable, and cross-platform solution that delivers reliable spatial data compliant with DIN 18202 regulatory standards, without the strict dependency on expensive, specialized hardware like LiDAR sensors.

**Current R&D Progress**
We have successfully validated our core measurement engine in simulated and controlled environments. The primary focus of our current R&D is optimizing the Neural Processing Unit (NPU) utilization for monocular depth estimation on Tier B devices (standard Android and iOS smartphones). We are actively refining our geometry cleanup algorithms and ensuring our Flutter-based UI maintains a strict 60Hz render target without inducing thermal throttling during prolonged scanning sessions.

**Core Features**
- **Hardware-Agnostic Scanning:** Purely software-driven spatial capture utilizing standard RGB cameras and IMU sensors.
- **On-Device ML Inference:** Real-time monocular depth estimation powered by NPU optimization.
- **Cross-Platform Consistency:** Unified user experience and business logic across Android and iOS via the Flutter framework.
- **Regulatory Compliant Outputs:** Measurement tolerances mapped to DIN 18202 standards for construction and spatial planning.
- **Secure Data Pipeline:** Encrypted point cloud processing with human-in-the-loop verification for billing integrity.

---

### 2. Visual Project Architecture & Flow Diagrams

#### System Architecture Overview

<img width="784" height="999" alt="arch" src="https://github.com/user-attachments/assets/ff3625a0-7293-4df9-ab23-d7e51bde4b4d" />


#### Data Flow: Layer 1 to Layer 4
- **Layer 1 (AR Tracking & Data Ingestion):** High-frequency ingestion of IMU data and RGB camera frames. Initial feature tracking and spatial anchoring are performed to establish the device's relative position.
- **Layer 2 (Depth Generation):** The NPU processes the RGB frames using our optimized ML models to generate dense monocular depth maps. 
- **Layer 3 (Point Cloud Assembly):** Depth maps are projected into 3D space using the SLAM trajectory data from Layer 1, accumulating into a raw, unoptimized point cloud.
- **Layer 4 (Geometry Cleanup):** Statistical outlier removal and voxel grid downsampling are applied. The cleaned point cloud is analyzed for planar surfaces to ensure measurements align with DIN 18202 tolerances.

---

### 3. The Non-LiDAR Approach (Crucial)

Our strategic approach for standard Android and iOS devices (Tier B) bypasses the need for hardware LiDAR. We bridge this hardware gap entirely through advanced software logic and edge AI.

**Monocular Depth via NPU-Based ML Inference**
Instead of relying on time-of-flight or structured light sensors, our engine utilizes proprietary Machine Learning models trained on extensive indoor and outdoor spatial datasets. These models predict depth from a single RGB camera feed (monocular depth). To achieve real-time performance, inference is strictly delegated to the device's Neural Processing Unit (NPU) or specialized AI accelerators (e.g., Apple Neural Engine, Snapdragon Hexagon DSP). This significantly unburdens the primary CPU and GPU.

**Performance and Thermal Management**
A critical challenge in continuous computer vision is thermal throttling. By leveraging the NPU for inference and optimizing our core engine in lower-level languages (C++/Rust) accessed via Flutter's Foreign Function Interface (FFI) or Platform Channels, we maintain a highly efficient execution pipeline. 

The Flutter UI layer is completely decoupled from these heavy processing threads. This architectural separation guarantees that the user interface remains highly responsive at a locked 60Hz, providing smooth visual feedback during scanning while preventing the device from overheating during extended operational periods. We intentionally do not categorize this approach as a replacement for specialized laser surveying equipment; instead, it is precisely calibrated to reliably meet DIN 18202 standards for practical spatial measurement and documentation.

---

### 4. Visual Development Roadmap & Plans

| Phase | Title | Key Objectives | Status |
| :--- | :--- | :--- | :--- |
| **Phase 0** | Foundation | Architecture design, Flutter project setup, CI/CD pipeline | Complete |
| **Phase 1** | Sensor Integration | IMU and Camera data ingestion, basic AR tracking (Layer 1) | Complete |
| **Phase 2** | ML Inference Pipeline | NPU delegate implementation, monocular depth model integration (Layer 2) | In Progress |
| **Phase 3** | Point Cloud Assembly | SLAM integration, 3D projection of depth maps (Layer 3) | Planned |
| **Phase 4** | Geometry & Cleanup | Voxel downsampling, planar detection, DIN 18202 calibration (Layer 4) | Planned |
| **Phase 5** | UI/UX Core Development | 60Hz rendering optimization, scanning feedback UI | Planned |
| **Phase 6** | Export & Processing | File format generation (OBJ, PLY), local storage management | Planned |
| **Phase 7** | Cloud Integration | Secure data upload, user authentication, profile management | Planned |
| **Phase 8** | Billing & Verification | Tri-state VOB/C billing schema, human-in-the-loop dashboard | Planned |
| **Phase 9** | Beta Testing (Internal) | Cross-device testing (Tier B), thermal profiling, accuracy audits | Planned |
| **Phase 10** | Pilot Release | Selected user group testing, real-world DIN 18202 validation | Planned |
| **Phase 11** | Production Release | Global rollout, continuous monitoring, post-launch support | Planned |

---

### 5. Data Integrity & Billing Schema

To ensure commercial viability and trust, our billing architecture for spatial data generation utilizes a rigorous Tri-State Confirmation Model, specifically designed around VOB/C (Vergabe- und Vertragsordnung für Bauleistungen) billing principles. 

**The Tri-State Confirmation Model**
1. **State 1: Raw Capture (Unverified):** The scan is completed on-device. The data exists locally and is flagged as pending.
2. **State 2: Algorithmic Validation (Pre-Verified):** The data is uploaded to our secure servers where automated scripts verify the structural integrity of the point cloud and ensure metadata (IMU drift, thermal state during scan) falls within acceptable parameters.
3. **State 3: Human-in-the-Loop (Confirmed):** A qualified operator reviews the pre-verified data. Only upon this final manual confirmation is the dataset locked, certified for DIN 18202 compliance, and processed for VOB/C billing.

#### Human-in-the-Loop Verification Flow

<img width="514" height="1286" alt="flow" src="https://github.com/user-attachments/assets/d5c14404-1e96-4f25-a2de-e19018374b29" />

