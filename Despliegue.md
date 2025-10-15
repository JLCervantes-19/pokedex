# Proceso de Despliegue - PokeDex en Azure Static Web Apps

Este documento detalla el proceso de despliegue de la aplicación PokeDex en Microsoft Azure utilizando **Azure Static Web Apps**.

---

## Prerequisitos

- ✅ Cuenta de **Azure for Students**
- ✅ Cuenta de **GitHub** con el código fuente del proyecto
- ✅ Aplicación Angular funcional

---

## 1. Creación de Azure Static Web App

### Paso 1: Crear Recurso en Azure

1. Ingresé a [Portal de Azure](https://portal.azure.com)
2. Busqué **"Static Web App"** y clic en **"Create"**
3. Configuré:
   - **Subscription:** Azure for Students
   - **Resource Group:** `pokedex-rg` (nuevo)
   - **Name:** `pokedex-webapp`
   - **Plan type:** Free
   - **Region:** East US 2

### Paso 2: Conectar con GitHub

1. **Source:** GitHub
2. Clic en **"Sign in with GitHub"** y autoricé a Azure
3. Configuré:
   - **Repository:** `pokedex-angular`
   - **Branch:** `main`
   - **Build Presets:** Angular
   - **App location:** `/`
   - **Output location:** `dist/pokedex-angular`

### Paso 3: Crear y Desplegar

1. Clic en **"Review + create"** → **"Create"**
2. Azure creó automáticamente:
   - El recurso Static Web App
   - Un workflow de GitHub Actions en `.github/workflows/`
   - El secret `AZURE_STATIC_WEB_APPS_API_TOKEN` en GitHub
3. El primer despliegue se ejecutó automáticamente (3-5 minutos)

**URL generada:** `https://[nombre-generado].azurestaticapps.net`

---

## 2. Configuración de Encabezados de Seguridad

Creé el archivo `staticwebapp.config.json` en la raíz del proyecto:

```json
{
  "globalHeaders": {
    "Strict-Transport-Security": "max-age=31536000; includeSubDomains",
    "X-Frame-Options": "SAMEORIGIN",
    "X-Content-Type-Options": "nosniff",
    "X-XSS-Protection": "1; mode=block",
    "Referrer-Policy": "no-referrer"
  },
  "navigationFallback": {
    "rewrite": "/index.html",
    "exclude": ["/images/*.{png,jpg,gif,svg}", "/css/*", "/js/*"]
  }
}
```

### Explicación de Encabezados

| Encabezado | Protección |
|------------|------------|
| `Strict-Transport-Security` | Fuerza HTTPS, previene ataques MITM |
| `X-Frame-Options` | Previene clickjacking |
| `X-Content-Type-Options` | Evita MIME sniffing |
| `X-XSS-Protection` | Protección contra XSS |
| `Referrer-Policy` | Previene fuga de información |

### Despliegue

```bash
git add staticwebapp.config.json
git commit -m "Add security headers configuration"
git push origin main
```

GitHub Actions desplegó automáticamente los cambios (3-4 minutos).

---

## 3. Verificación de SSL/TLS

Azure Static Web Apps incluye:
- ✅ Certificados SSL gratuitos automáticos
- ✅ Renovación automática
- ✅ Redirección HTTP → HTTPS automática
- ✅ TLS 1.2 y 1.3

Verificación:
```bash
curl -I https://[tu-app].azurestaticapps.net
```

---

## 4. Verificación y Pruebas

### Prueba 1: Escaneo de Seguridad

1. Accedí a [https://securityheaders.com/](https://securityheaders.com/)
2. Ingresé mi URL
3. Clic en **"Scan"**

**Resultado:** Calificación **A**

### Prueba 2: Verificar Aplicación

Probé en navegador:
- ✅ Aplicación carga correctamente
- ✅ HTTPS activo (candado verde)
- ✅ Sin errores en consola
- ✅ Rutas Angular funcionan
- ✅ API calls a PokeAPI funcionan

### Prueba 3: CI/CD Automático

```bash
# Hacer cambio de prueba
echo "<!-- Test -->" >> src/index.html
git add . && git commit -m "Test deployment" && git push
```

✅ GitHub Actions desplegó automáticamente en 3-4 minutos.

---

## 5. Problemas Encontrados y Soluciones

### Problema 1: Error de Build Artifact - Output Location Incorrecta

**Error en GitHub Actions:**
```
The app build failed to produce artifact folder: 'dist/FAEIT.Legacy.IP.Client'
```

**Contexto:**
Durante el despliegue automático mediante GitHub Actions hacia Azure Static Web Apps, el pipeline fallaba en la etapa de "Build and Deploy". Azure no encontraba los archivos del build generados por Angular, deteniendo la publicación de la aplicación.

**Causa del error:**
El problema se originó en la configuración del workflow (`.github/workflows/production.yml`). El valor configurado era:
```yaml
output_location: "dist/FAEIT.Legacy.IP.Client"
```

Sin embargo, según `angular.json`, el proyecto genera su salida en:
```json
"outputPath": "dist/pokedex-angular"
```

Azure buscaba archivos en una carpeta que **no existía**.

**Solución:**
1. Ubiqué el archivo `.github/workflows/production.yml`
2. Edité la sección de despliegue:

   **Antes:**
   ```yaml
   output_location: "dist/FAEIT.Legacy.IP.Client"
   ```

   **Después:**
   ```yaml
   output_location: "dist/pokedex-angular"
   ```

3. Confirmé que la raíz del proyecto esté correcta:
   ```yaml
   app_location: "/"
   ```

4. Commit y push:
   ```bash
   git add .github/workflows/production.yml
   git commit -m "Fix: Corrige ruta de carpeta dist para despliegue en Azure"
   git push origin main
   ```

**Resultado:**
```
✅ Found app artifact folder: dist/pokedex-angular
✅ Deployment successful
```

**Recomendaciones:**
- Mantener sincronizados los nombres entre `angular.json` y archivos `.yml`
- Revisar `"outputPath"` en `angular.json` antes de configurar pipelines
- Ejecutar `ng build --configuration production` localmente para confirmar la ruta

### Problema 2: Rutas Angular Devuelven 404

**Error:** Rutas directas como `/pokemon/25` devuelven 404

**Solución:**
Agregué `navigationFallback` en `staticwebapp.config.json`:
```json
{
  "navigationFallback": {
    "rewrite": "/index.html"
  }
}
```

### Problema 3: Build Falla por Dependencias

**Error:**
```
npm ERR! ERESOLVE unable to resolve dependency tree
```

**Solución:**
Edité `.github/workflows/azure-static-web-apps-*.yml`:
```yaml
env:
  NPM_CONFIG_LEGACY_PEER_DEPS: true
```

---

## 6. Comandos Útiles

### Desplegar Cambios
```bash
git add .
git commit -m "Descripción del cambio"
git push origin main
# GitHub Actions despliega automáticamente
```

### Ver Logs de Deployment
GitHub → Actions → Seleccionar workflow más reciente

### Revertir Cambios
```bash
git log --oneline
git revert HEAD
git push origin main
```

---

## Conclusión

Despliegue completado exitosamente con:

✅ **Aplicación accesible:** HTTPS automático
✅ **Encabezados de seguridad:** Calificación A
✅ **CI/CD automático:** GitHub Actions
✅ **Costo:** $0 USD/mes (Free tier)
✅ **Tiempo de setup:** 20-30 minutos

### Ventajas de Azure Static Web Apps

| Característica | Beneficio |
|----------------|-----------|
| **SSL automático** | Certificados gratuitos con renovación automática |
| **CI/CD integrado** | Despliegue automático con cada push |
| **CDN global** | Baja latencia en todo el mundo |
| **Sin servidores** | No hay infraestructura que mantener |
| **Costo** | Gratis para proyectos pequeños |

### Recursos

- **Aplicación:** https://[tu-app].azurestaticapps.net
- **Repositorio:** https://github.com/[usuario]/pokedex-angular
- **Portal Azure:** https://portal.azure.com
- **Escaneo de Seguridad:** https://securityheaders.com/

**Fecha de despliegue:** Octubre 2025
**Plataforma:** Azure Static Web Apps
**Estado:** ✅ Producción
# 🧩 Error de Despliegue en Azure Static Web Apps — Proyecto *pokedex-angular*

## 🧠 Contexto del Problema

Durante el proceso de despliegue automático mediante **GitHub Actions** hacia **Azure Static Web Apps**, el pipeline fallaba en la etapa de **"Build and Deploy"** mostrando el siguiente mensaje de error:

```
The app build failed to produce artifact folder: 'dist/FAEIT.Legacy.IP.Client'
```

Este error impedía que Azure encontrara los archivos del build generados por Angular, deteniendo así la publicación de la aplicación.

---

## 🚨 Causa del Error

El problema se originó en la configuración del flujo de trabajo (`.github/workflows/production.yml`), específicamente en el parámetro `output_location`.

En dicho archivo, el valor configurado era:

```yaml
output_location: "dist/FAEIT.Legacy.IP.Client"
```

Sin embargo, según la configuración del archivo `angular.json`, el proyecto **pokedex-angular** genera su salida de compilación en:

```json
"outputPath": "dist/pokedex-angular"
```

Esto significa que Azure estaba buscando los archivos en una carpeta que **no existía**, por lo que el despliegue fallaba.

---

## ✅ Solución Implementada

1. **Ubicar el archivo de workflow en el repositorio:**

   ```
   .github/workflows/production.yml
   ```

2. **Editar la sección del despliegue**, reemplazando la ruta incorrecta por la correcta según `angular.json`.

   **Antes:**
   ```yaml
   output_location: "dist/FAEIT.Legacy.IP.Client"
   ```

   **Después:**
   ```yaml
   output_location: "dist/pokedex-angular"
   ```

3. **Confirmar que la raíz del proyecto esté bien referenciada:**

   ```yaml
   app_location: "/"
   ```

4. **Guardar los cambios y hacer commit:**
   ```bash
   git add .github/workflows/production.yml
   git commit -m "Corrige ruta de carpeta dist para despliegue en Azure"
   git push origin main
   ```

5. **Verificar en GitHub Actions** que el flujo de despliegue se ejecute correctamente.

---

## 💡 Resultado

Tras aplicar la corrección, el pipeline detectó correctamente la carpeta de artefactos del build y completó el despliegue sin errores, mostrando mensajes como:

```
✅ Found app artifact folder: dist/pokedex-angular
✅ Deployment successful
```

---

## 📚 Recomendaciones

- Mantener sincronizados los nombres de carpetas entre `angular.json` y los flujos de despliegue (`.yml`).
- Revisar el campo `"outputPath"` en `angular.json` antes de configurar o actualizar los pipelines.
- Ejecutar localmente `ng build --configuration production` para confirmar la ruta de salida antes de desplegar.
- En caso de advertencias de tamaño (“Budget exceeded”), pueden ajustarse los límites en `angular.json` o realizar optimizaciones en la app.

---

**Autor:**  
👤 *Jhan Leider Cervantes Carrillo*
*Abraham Guzman*
*Hans Castellar*
📅 *15 de October de 2025*
