# PharmaGo Mobile 🏥

Application Flutter de localisation des pharmacies de garde à Lomé, Togo.

## Aperçu

PharmaGo permet aux habitants de Lomé de trouver rapidement les pharmacies de garde les plus proches, avec ou sans connexion internet.

## Fonctionnalités

- Géolocalisation automatique des pharmacies proches
- Recherche par quartier si géoloc refusée
- Fiches détail avec appel, WhatsApp et itinéraire directs
- Mode offline — données accessibles sans connexion
- Signalement d'erreurs sur les informations affichées
- Partage des infos d'une pharmacie via WhatsApp

## Stack technique

| Catégorie | Technologie |
|---|---|
| Framework | Flutter 3.x / Dart 3.x |
| State management | Riverpod 2.x |
| HTTP | Dio 5.x |
| Navigation | go_router 14.x |
| Géolocalisation | geolocator 13.x |
| Cache offline | shared_preferences 2.x |
| Animations | flutter_animate 4.x |

## Backend

API REST Spring Boot déployée sur Railway :
```
https://phramago-backend-production.up.railway.app
```

Documentation Swagger :
```
https://phramago-backend-production.up.railway.app/swagger-ui.html
```

## Architecture

```
lib/
├── core/               # Config globale (theme, router, réseau, erreurs)
├── features/
│   ├── pharmacies/     # Liste et détail des pharmacies
│   ├── signalements/   # Formulaire de signalement
│   └── splash/         # Écran de démarrage
└── shared/             # Widgets, services et providers partagés
```

## Lancer le projet

### Prérequis

- Flutter SDK >= 3.11
- Dart SDK >= 3.11
- Android Studio ou un appareil Android avec débogage USB activé

### Installation

```bash
git clone https://github.com/edgard1602/PharmaGo-Mobile.git
cd PharmaGo-Mobile
flutter pub get
flutter run
```

### Lancer sur Android

```bash
# Vérifier les appareils connectés
flutter devices

# Lancer sur un appareil spécifique
flutter run -d <device_id>

# Build APK de production
flutter build apk --release
```

## Workflow Git

```
main        → code stable et testé
develop     → branche d'intégration
feature/*   → une branche par fonctionnalité
fix/*       → corrections de bugs
```

```bash
# Démarrer une feature
git checkout develop
git checkout -b feature/nom-fonctionnalite

# Commits conventionnels
feat(home): add pharmacy list screen
fix(geo): fix distance calculation
chore(deps): update flutter_riverpod to 2.6.1
```

## Identité visuelle

| Rôle | Couleur | Hex |
|---|---|---|
| Primaire | Vert médical | `#00A651` |
| Accent | Bleu | `#0066CC` |
| Urgence | Rouge | `#E63946` |
| WhatsApp | Vert WA | `#25D366` |
| Background | Gris clair | `#F8F9FA` |

## Roadmap

- [ ] Tests unitaires et widget tests
- [ ] Carte Google Maps intégrée
- [ ] Notifications push pour les changements de garde
- [ ] Marketplace pharmacies partenaires (PharmaGo V2)
- [ ] Dashboard administrateur web

## Auteur

**Edgard Padasse** — Junior Backend Developer / Flutter  
Lomé, Togo