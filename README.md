Virtual Wardrobe App
# 👗 Virtual Wardrobe App
===

# 

# A Flutter-based web application with Firebase backend for managing your personal wardrobe digitally.

# 

# \---

# 

# \## 📌 Project Info

# 

# | Detail | Info |

# |--------|------|

# | \*\*Project Type\*\* | Mini Project — Human Application Development (HAD) |

# | \*\*Institution\*\* | Nitte Meenakshi Institute of Technology (NMIT), Bengaluru |

# | \*\*Department\*\* | Information Science and Engineering |

# | \*\*Academic Year\*\* | 2025–2026 |

# | \*\*Guide\*\* | Mr. Prashanth B S, Assistant Professor, Dept. of ISE |

# 

# \---

# 

# \## 👩‍💻 Team Members

# 

# | Name | USN |

# |------|-----|

# | Anusha K M | 1NT23IS030 |

# | Bhagyajyoti G | 1NT23IS047 |

# | Bhavana P K | 1NT23IS049 |

# | Chandana S | 1NT23IS057 |

# 

# \---

# 

# \## 📱 About the App

# 

# The \*\*Virtual Wardrobe App\*\* is a cloud-based web application that helps users digitally catalogue, organise, and manage their personal clothing collection. Users can upload clothing images, categorise items, build outfit combinations, mark favourites, and analyse their wardrobe through visual statistics — all from a browser, without installation.

# 

# \---

# 

# \## ✨ Features

# 

# \- 🔐 \*\*User Authentication\*\* — Register and login with persistent session management

# \- 👕 \*\*Add Clothing Items\*\* — Upload images with name, category, style type, and colour

# \- 🗂️ \*\*Category Filter\*\* — Filter wardrobe by Tops, Bottoms, Footwear, Ethnic, Formal, etc.

# \- 🖼️ \*\*Full-Screen Image Viewer\*\* — Swipe between items, pinch to zoom up to 6×

# \- ❤️ \*\*Favourites\*\* — Mark and unmark clothing items as favourites

# \- 👗 \*\*Outfit Builder\*\* — Combine top, bottom, and footwear into a complete outfit preview

# \- 📊 \*\*Wardrobe Statistics\*\* — Visual progress bars showing category distribution

# \- ☁️ \*\*Cloud Storage\*\* — All data stored in Firebase Firestore, persists across sessions

# \- ⚡ \*\*Optimistic UI\*\* — Items appear instantly without waiting for server confirmation

# \- 🔒 \*\*Data Privacy\*\* — Each user's data isolated via Firestore security rules

# 

# \---

# 

# \## 🛠️ Tech Stack

# 

# | Component | Technology |

# |-----------|------------|

# | Frontend Framework | Flutter 3.x (Dart) |

# | Authentication | Firebase Authentication |

# | Database | Cloud Firestore (NoSQL) |

# | State Management | Provider Pattern (ChangeNotifier) |

# | Image Handling | image\_picker + Base64 encoding |

# | Typography | Google Fonts — Poppins |

# | Unique IDs | UUID version 4 |

# | Version Control | Git + GitHub |

# 

# \---

# 

# \## 🏗️🏗️ Architecture

# 

The app follows a \*\*three-layer architecture\*\*:
---
===

# 

\## 📂 Project Structure
wardrobe\_app/
===

# ├── lib/

# │ ├── main.dart

# │ ├── firebase\_options.dart

# │ ├── models/

# │ │ └── clothing\_item.dart

# │ ├── providers/

# │ │ ├── auth\_provider.dart

# │ │ └── wardrobe\_provider.dart

# │ ├── screens/

# │ │ ├── login\_screen.dart

# │ │ ├── home\_screen.dart

# │ │ ├── add\_item\_screen.dart

# │ │ ├── image\_viewer\_screen.dart

# │ │ ├── outfit\_screen.dart

# │ │ └── stats\_screen.dart

# │ └── widgets/

# │ └── clothing\_card.dart

# ├── pubspec.yaml

└── README.md
---
===

# 

# \## 🚀 Getting Started

# 

# \### Prerequisites

# \- Flutter SDK installed and added to PATH

# \- A Firebase project with Authentication and Firestore enabled

# \- Google Chrome (for web)

# 

# \### Setup Steps

# 

# 1\. \*\*Clone the repository\*\*

# ```bash

# git clone https://github.com/Bhagyajyoti-123/wardrobe\_app.git

# cd wardrobe\_app

# ```

# 

# 2\. \*\*Install dependencies\*\*

# ```bash

# flutter pub get

# ```

# 

# 3\. \*\*Configure Firebase\*\*

# &#x20;  - Go to \[Firebase Console](https://console.firebase.google.com)

# &#x20;  - Create a project and register a web app

# &#x20;  - Copy your config values into `lib/firebase\_options.dart`

# &#x20;  - Enable Email/Password Authentication

# &#x20;  - Create a Firestore database in test mode

# 

# 4\. \*\*Run the app\*\*

# ```bash

# flutter run -d chrome

# ```

# 

# \---

# 

\## 🔐 Firestore Security Rules
rules\_version = '2';
===

# service cloud.firestore {

# match /databases/{database}/documents {

# match /users/{userId}/wardrobe/{itemId} {

# allow read, write: if request.auth != null

# \&\& request.auth.uid == userId;

# }

# }

}
---
===

# 

# \## 📦 Dependencies

# 

# ```yaml

# dependencies:

# &#x20; flutter:

# &#x20;   sdk: flutter

# &#x20; firebase\_core: ^3.3.0

# &#x20; firebase\_auth: ^5.1.4

# &#x20; cloud\_firestore: ^5.2.1

# &#x20; provider: ^6.1.2

# &#x20; image\_picker: ^1.0.7

# &#x20; google\_fonts: ^6.2.1

# &#x20; uuid: ^4.3.3

# ```

# 

# \---

# 

# \## 🧪 Testing

# 

# All 20 black-box functional test cases passed successfully covering:

# \- User registration and login

# \- Item add, delete, and favourite toggle

# \- Category filtering

# \- Image viewer swipe and zoom

# \- Outfit builder preview

# \- Statistics display

# \- Data persistence across sessions

# 

# \---

# 

# \## 🔮 Future Scope

# 

# \- 🤖 AI-based outfit suggestions using machine learning

# \- 🌤️ Weather-integrated clothing recommendations

# \- 💾 Save and name outfit combinations

# \- 🔍 Advanced search with multi-parameter filtering

# \- 🧺 Laundry status tracker per item

# \- 💰 Cost-per-wear analytics

# \- 📱 Android and iOS native app support

# 

# \---

# 

# \## 📄 License

# 

# This project was developed as a mini project for academic purposes at NMIT, Bengaluru.

# 

# \---

# 

# \*Built with ❤️ using Flutter and Firebase\*

