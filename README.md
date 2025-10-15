# Pokédex Angular - Pueblo Paleta Inc.

[![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg)](https://github.com/prettier/prettier)
[![codecov](https://codecov.io/gh/keilermora/pokedex-angular/branch/master/graph/badge.svg?token=9E0D28IOFT)](https://codecov.io/gh/keilermora/pokedex-angular)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)

## 🚀 URL de Producción

**Aplicación desplegada:** [https://lemon-river-0c3396810.2.azurestaticapps.net](https://lemon-river-0c3396810.2.azurestaticapps.net)

---

## 📖 Descripción del Proyecto

La aplicación muestra el listado y el detalle de los Pokémon de las primeras 3 generaciones.

La imagen que representa un Pokémon en el listado muestra las variaciones que estos tuvieron durante las primeras versiones, desde la versión Green (1996) hasta la version Emerald (2005).

Los detalles de un Pokémon individual muestra sus estadísticas base y los registros de la Pokédex de las diferentes versiones.

El proyecto fue desarrollado usando [Angular](https://angular.io/) para crear la interfaz de usuario, en comunicación con la API RESTful [PokéAPI](https://pokeapi.co/).

---

## ☁️ Despliegue en Azure

### Plataforma Utilizada

**Azure Static Web Apps** - Servicio optimizado para aplicaciones front-end con:
- ✅ SSL/TLS automático
- ✅ CI/CD con GitHub Actions
- ✅ CDN global
- ✅ Costo: $0 USD/mes (Free tier)

### Información del Recurso Azure

| Propiedad | Valor |
|-----------|-------|
| **Nombre del recurso** | `swa-pokedex-font-prod` |
| **Grupo de recursos** | `rg-pokedex-prod` |
| **Región** | Central US |
| **Plan** | Free |
| **URL generada** | lemon-river-0c3396810.2.azurestaticapps.net |
| **Repositorio** | https://github.com/JLCervantes-19/pokedex |
| **Branch** | main |
| **IP estática** | 20.84.233.22 |

### Proceso de Creación de Cuenta

#### 1. Activación de Azure for Students

1. Accedí a [Azure for Students](https://azure.microsoft.com/es-es/free/students/)
2. Inicié sesión con mi cuenta institucional universitaria
3. Azure verificó automáticamente mi elegibilidad como estudiante

**Beneficios obtenidos:**
- $100 USD en créditos (válidos 12 meses)
- Servicios gratuitos sin tarjeta de crédito
- Acceso a herramientas de desarrollo

#### 2. Configuración Inicial

1. Accedí al [Portal de Azure](https://portal.azure.com)
2. Verifiqué la suscripción "Azure for Students" activa
3. Creé el grupo de recursos `rg-pokedex-prod` en región **Central US**

#### 3. Creación de Static Web App

1. Busqué "Static Web App" en Azure Portal → **Create**
2. Configuré los detalles básicos:
   - **Name:** `swa-pokedex-font-prod`
   - **Resource Group:** `rg-pokedex-prod`
   - **Region:** Central US
   - **Plan type:** Free
3. Conecté con GitHub y autoricé el acceso
4. Seleccioné el repositorio `JLCervantes-19/pokedex` y configuré:
   - **Branch:** main
   - **Build Preset:** Angular
   - **Output location:** `dist/pokedex-angular`
5. Azure creó automáticamente:
   - El recurso Static Web App
   - Workflow de GitHub Actions (`.github/workflows/`)
   - Token de deployment en GitHub Secrets

**URL generada automáticamente:** `https://lemon-river-0c3396810.2.azurestaticapps.net`

**Documentación completa:** Ver [Despliegue.md](Despliegue.md)

---

## 🔒 Seguridad Implementada

### Encabezados de Seguridad

Configurados en `staticwebapp.config.json`:

| Encabezado | Función |
|------------|---------|
| `Strict-Transport-Security` | Fuerza HTTPS, previene ataques MITM |
| `X-Frame-Options` | Previene clickjacking |
| `X-Content-Type-Options` | Evita MIME sniffing |
| `X-XSS-Protection` | Protección contra XSS |
| `Referrer-Policy` | Previene fuga de información |

**Calificación obtenida:** **A** en [securityheaders.com](https://securityheaders.com/)

### Certificado SSL

- ✅ Certificado gratuito de Microsoft Azure
- ✅ Renovación automática
- ✅ TLS 1.2 y 1.3
- ✅ Redirección HTTP → HTTPS automática

---

## 💭 Reflexión Técnica

### ¿Qué vulnerabilidades previenen los encabezados implementados?

**1. Strict-Transport-Security (HSTS)**
- Previene ataques de downgrade (forzar HTTP en lugar de HTTPS)
- Protege contra man-in-the-middle (MITM)
- Obliga a los navegadores a usar siempre conexiones seguras

**2. X-Frame-Options**
- Previene clickjacking
- Evita que la aplicación sea embebida en iframes maliciosos
- Protege contra ataques de UI redressing

**3. X-Content-Type-Options**
- Previene MIME type sniffing
- Evita que archivos maliciosos se ejecuten como scripts
- Reduce el riesgo de ejecución de código no autorizado

**4. X-XSS-Protection**
- Activa el filtro XSS del navegador
- Bloquea la página si detecta ataques XSS reflejados
- Capa adicional de protección contra Cross-Site Scripting

**5. Referrer-Policy**
- Previene fuga de información sensible en URLs
- Protege la privacidad de los usuarios
- Evita que otros sitios conozcan el origen de las visitas

### ¿Qué aprendiste sobre la relación entre despliegue y seguridad web?

**1. La seguridad debe ser parte integral del despliegue**
No es opcional ni puede agregarse después. Un despliegue sin consideraciones de seguridad expone la aplicación y a los usuarios a riesgos innecesarios.

**2. HTTPS es fundamental**
Los certificados gratuitos (como los de Azure) democratizan el acceso a conexiones seguras. No hay excusa para no usar HTTPS en producción.

**3. Defensa en profundidad**
Los encabezados HTTP son una capa adicional. La seguridad efectiva requiere múltiples capas: cifrado, encabezados, CSP, autenticación, etc.

**4. Automatización reduce errores**
La renovación automática de certificados SSL y la configuración mediante código (IaC) eliminan errores humanos y mejoran la seguridad a largo plazo.

**5. Validación continua**
Herramientas como securityheaders.com permiten validar objetivamente la postura de seguridad. La seguridad requiere monitoreo y mejora continua.

### ¿Qué desafíos encontraste en el proceso?

**1. Configuración de Output Location**
- **Desafío:** GitHub Actions fallaba porque buscaba archivos en `dist/FAEIT.Legacy.IP.Client` en lugar de `dist/pokedex-angular`
- **Solución:** Sincronicé la configuración del workflow con `angular.json`
- **Aprendizaje:** Importancia de mantener consistencia entre archivos de configuración

**2. Rutas de Angular (SPA Routing)**
- **Desafío:** Rutas directas devolvían 404 porque el servidor no conoce las rutas de Angular
- **Solución:** Configuré `navigationFallback` para redirigir todo a `index.html`
- **Aprendizaje:** Las SPAs requieren configuración especial en el servidor

**3. Content Security Policy**
- **Desafío:** CSP bloqueaba imágenes de PokeAPI (dominio externo)
- **Solución:** Ajusté la política para permitir `https://raw.githubusercontent.com`
- **Aprendizaje:** Balance entre seguridad y funcionalidad

**4. Dependencias de Node.js**
- **Desafío:** Conflictos de versiones entre paquetes de Angular
- **Solución:** Usé flag `NPM_CONFIG_LEGACY_PEER_DEPS: true`
- **Aprendizaje:** Los proyectos heredados pueden requerir flags de compatibilidad

---

## 🛠️ Requisitos Mínimos

- [Node.js](https://nodejs.org) LTS (Long Term Support)
- Un navegador web moderno

---

## 🧪 Ambiente de Desarrollo

Ejecutar en la raíz del proyecto:

```bash
npm install
npm start
```

La aplicación estará disponible en `http://localhost:4200/`

---

## 📚 Referencias

- [Angular](https://angular.io/) - Framework de desarrollo
- [Angular Folder Structure](https://angular-folder-structure.readthedocs.io/en/latest/) - Estructura de carpetas
- [Font Awesome](https://fontawesome.com/) - Iconos
- [Normalize.css](https://necolas.github.io/normalize.css/) - Reset de CSS
- [PokéAPI](https://pokeapi.co/) - API RESTful de Pokémon
- [Azure Static Web Apps](https://azure.microsoft.com/en-us/services/app-service/static/) - Plataforma de hosting

---

## 👥 Equipo

**Autores:**
- Jhan Leider Cervantes Carrillo
- Abraham Guzmán
- Hans Castellar

**Fecha:** Octubre 2025
**Proyecto:** Sistemas Distribuidos - UNAM