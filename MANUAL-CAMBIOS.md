# MANUAL DE CAMBIOS — OneTools

> Este archivo explica paso a paso cómo hacer los cambios más comunes en OneTools.
> Está escrito para que un asistente de IA (Codex u otro) lo siga al pie de la letra.
> **Sigue los pasos EXACTAMENTE. No inventes pasos. No cambies nombres ni rutas.**

---

## 0. MAPA DEL SISTEMA (leer antes de tocar nada)

OneTools entrega juegos de Steam a clientes que pagaron. El cliente ejecuta este
comando en PowerShell y NUNCA cambia:

```
irm "https://onetools.lat/install.ps1" | iex
```

**Dónde vive cada cosa:**

| Cosa | Dónde está | Para qué |
|---|---|---|
| Scripts `.ps1` | Repo GitHub `JesusVite/OneTools` | El código que se ejecuta |
| Zips de juegos `.zip` | Cloudflare R2, bucket `onetools-packs`, carpeta `pack4/` | Los archivos de cada juego |
| Lista de nombres de juegos | Dentro de `pack4_pedido.ps1`, variable `$TODOS` | El menú que ve el cliente |
| Códigos de orden | Supabase, proyecto `phvbomzwynbmahxeatab`, tabla `ordenes` | Quién puede instalar |
| Validación y firma de URLs | Supabase Edge Function `firmar-descarga` | Seguridad |

**Repo local (clonar si no existe):**
```
git clone --filter=blob:none --no-checkout --depth 1 https://github.com/JesusVite/OneTools.git C:\Scripts\OneTools
cd C:\Scripts\OneTools
git sparse-checkout init --no-cone
echo /*> .git\info\sparse-checkout
echo !packs/>> .git\info\sparse-checkout
git checkout
```
> IMPORTANTE: clonar SIEMPRE en sparse-mode excluyendo `packs/`. El repo tiene
> cientos de zips viejos commiteados que rompen un `git clone` normal (se cuelga).

---

## REGLA DE ORO (si rompes esto, nada funciona)

> **El nombre del archivo en R2 debe ser EXACTAMENTE igual al texto en la lista `$TODOS`.**
>
> Ejemplo: si en R2 el archivo se llama `pack4/Hollow Knight.zip`, en la lista
> `$TODOS` debe decir EXACTAMENTE `"Hollow Knight.zip"` — mismos espacios, mismas
> mayúsculas, mismos símbolos (™, ®, etc.). Si difieren aunque sea en un espacio,
> la descarga de ese juego falla.

---

## TAREA 1: AÑADIR UN JUEGO NUEVO

Esto tiene **2 partes**: (A) subir el zip a R2, y (B) agregar el nombre al script.
Hay que hacer LAS DOS o no funciona.

### Parte A — Subir el zip a Cloudflare R2

El zip debe contener, sin subcarpetas internas:
- Un archivo `.lua` cuyo nombre sea el **AppID** del juego en Steam (ejemplo: `1086940.lua`).
- Uno o varios archivos `.manifest`.

**Método 1 — Dashboard web (recomendado, fácil para 1-5 juegos):**

1. Entrar a https://dash.cloudflare.com
2. Menú izquierdo → **R2** → click en el bucket **`onetools-packs`**.
3. Click en la carpeta **`pack4`**.
4. Click en el botón **"Upload"** → **"Upload file"**.
5. Seleccionar el `.zip` del juego desde tu PC.
6. Esperar a que suba. El archivo debe quedar como `pack4/<Nombre del juego>.zip`.
7. ANOTAR el nombre EXACTO con que quedó (lo necesitas en la Parte B).

> El bucket es PRIVADO. No se accede por URL pública. Subir desde el dashboard
> funciona igual (el "privado" solo bloquea la descarga pública, no la gestión).

**Método 2 — rclone (para subir muchos juegos de golpe):**

Solo configurar UNA vez:
1. Descargar rclone de https://rclone.org/downloads/ (versión Windows).
2. Correr `rclone config` y crear un remote tipo "Amazon S3" → proveedor "Cloudflare R2"
   con el Access Key ID y Secret Access Key del token R2 (los tiene Jesús).
   El endpoint es: `https://db0b65afa174383054a0c4367a692745.r2.cloudflarestorage.com`
3. Subir una carpeta entera de zips:
   ```
   rclone copy "C:\ruta\a\mis\zips" miremote:onetools-packs/pack4 --progress
   ```

### Parte B — Agregar el nombre al script

1. Abrir el archivo `C:\Scripts\OneTools\pack4_pedido.ps1`.
2. Buscar la línea que dice `$TODOS = @(` (cerca de la línea 155).
3. La lista termina con una línea que dice `)` (cerca de la línea 515). La última
   entrada de juego NO tiene coma al final.
4. Agregar el juego nuevo. La forma MÁS SEGURA es agregarlo en medio de la lista
   (no al final, para no pelear con la coma). Por ejemplo, después de la primera línea:

   ANTES:
   ```
   $TODOS = @(
       "60 Second Strike.zip",
   ```
   DESPUÉS (agregaste "Mi Juego Nuevo.zip"):
   ```
   $TODOS = @(
       "Mi Juego Nuevo.zip",
       "60 Second Strike.zip",
   ```
   > Fíjate: la línea nueva lleva 4 espacios de sangría, comillas dobles, el nombre
   > EXACTO con `.zip`, y una coma al final.

5. Guardar el archivo.

### Parte C — Subir el cambio a GitHub

En PowerShell, dentro de `C:\Scripts\OneTools`:
```
cd C:\Scripts\OneTools
git add pack4_pedido.ps1
git commit -m "Agregar juego: Mi Juego Nuevo"
git push origin main
```

### Parte D — Verificar

Esperar 1 minuto y ejecutar el comando de cliente con un código de prueba:
```
irm "https://onetools.lat/install.ps1" | iex
```
Buscar el juego nuevo en la lista numerada, seleccionarlo y confirmar que descarga.

---

## TAREA 2: QUITAR UN JUEGO

1. Abrir `C:\Scripts\OneTools\pack4_pedido.ps1`.
2. Buscar la línea del juego dentro de `$TODOS` (ejemplo: `"Mi Juego Viejo.zip",`).
3. Borrar esa línea completa. (Cuidado: si era la ÚLTIMA de la lista, asegúrate de
   que la nueva última línea NO tenga coma al final, antes del `)`.)
4. Guardar.
5. Subir a GitHub:
   ```
   cd C:\Scripts\OneTools
   git add pack4_pedido.ps1
   git commit -m "Quitar juego: Mi Juego Viejo"
   git push origin main
   ```
6. (Opcional) Borrar también el zip de R2 desde el dashboard de Cloudflare.

---

## TAREA 3: AGREGAR CÓDIGOS DE ORDEN (para nuevos clientes)

1. Entrar a https://supabase.com/dashboard/project/phvbomzwynbmahxeatab/sql/new
2. Pegar este SQL (cambiar los códigos por los que quieras). Formato sugerido
   `ONE-XXXX-XXXX` con letras y números, evitando O/0 e I/1 para no confundir:
   ```sql
   INSERT INTO ordenes (codigo, notas) VALUES
     ('ONE-A1B2-C3D4', 'Cliente Juan'),
     ('ONE-E5F6-G7H8', 'Cliente Maria')
   ON CONFLICT (codigo) DO NOTHING;
   ```
3. Click en **Run** (o Ctrl+Enter).
4. Debe decir "Success". Ya puedes entregar esos códigos a clientes.

---

## TAREA 4: LIBERAR UN CÓDIGO (cliente cambió de PC)

Cuando un cliente cambia de computadora, su código queda "pegado" a la PC vieja.
Para liberarlo:

**Opción rápida (SQL):**
1. Entrar a https://supabase.com/dashboard/project/phvbomzwynbmahxeatab/sql/new
2. Pegar (cambiar el código por el del cliente):
   ```sql
   UPDATE ordenes SET device_id = NULL, usado_at = NULL
   WHERE codigo = 'ONE-A1B2-C3D4';
   ```
3. Click **Run**. El cliente ya puede usar su código en la PC nueva.

**Opción visual:**
1. Entrar a https://supabase.com/dashboard/project/phvbomzwynbmahxeatab/editor
2. Click en la tabla **`ordenes`**.
3. Buscar la fila del código, editar la celda `device_id` y dejarla vacía (NULL).
4. Guardar.

---

## TAREA 5: VER ACTIVIDAD / QUIÉN USÓ QUÉ

1. Entrar a https://supabase.com/dashboard/project/phvbomzwynbmahxeatab/sql/new
2. Para ver el resumen por código:
   ```sql
   SELECT * FROM panel_admin;
   ```
3. Para ver TODOS los movimientos (intentos, descargas, bloqueos):
   ```sql
   SELECT * FROM auditoria ORDER BY creado_at DESC LIMIT 50;
   ```
4. Si ves muchos `rate_limited` o `sospechoso` de un mismo código → alguien está
   intentando abusar. Puedes investigarlo o bloquearlo.

---

## TAREA 6: CAMBIAR UN MENSAJE / TEXTO DEL SCRIPT

Los textos que ve el cliente están en `pack4_pedido.ps1` y `onetools_encadenador.ps1`
dentro de líneas `Write-Host "..."`. Para cambiarlos:

1. Abrir el archivo correspondiente en `C:\Scripts\OneTools\`.
2. Buscar el texto a cambiar (ejemplo: `"Pedido completado con exito!"`).
3. Editarlo (mantener las comillas y la estructura de la línea).
4. Guardar y subir a GitHub:
   ```
   cd C:\Scripts\OneTools
   git add .
   git commit -m "Cambiar mensaje X"
   git push origin main
   ```

> El comando del cliente (`irm onetools.lat/install.ps1 | iex`) NUNCA cambia.
> Solo cambian los archivos internos. El cliente siempre recibe la última versión.

---

## DATOS DE REFERENCIA

| Dato | Valor |
|---|---|
| Repo GitHub | `https://github.com/JesusVite/OneTools` |
| Comando cliente | `irm "https://onetools.lat/install.ps1" \| iex` |
| Bucket R2 | `onetools-packs`, carpeta `pack4/` |
| R2 Account ID | `db0b65afa174383054a0c4367a692745` |
| R2 Endpoint | `https://db0b65afa174383054a0c4367a692745.r2.cloudflarestorage.com` |
| Supabase proyecto | `phvbomzwynbmahxeatab` |
| Supabase URL | `https://phvbomzwynbmahxeatab.supabase.co` |
| Supabase anon key (pública) | `sb_publishable_FhIq7tTb_ieoQudbsPyzcg_PCrYK7gv` |
| Edge Function | `https://phvbomzwynbmahxeatab.supabase.co/functions/v1/firmar-descarga` |
| Archivo lista de juegos | `pack4_pedido.ps1`, variable `$TODOS` |
| Archivo wrapper onetools.lat | repo `game-access-key`, `public/install.ps1` |

> **SECRETOS (NUNCA en git, NUNCA en archivos públicos):** el R2 Secret Access Key
> y el service_role de Supabase. Solo viven en los secrets de la Edge Function de
> Supabase. Si se pierde el R2 Secret, hay que crear un token R2 nuevo en Cloudflare
> y actualizar los secrets de la Edge Function.

---

## REGLAS QUE NO SE DEBEN ROMPER

1. El nombre del zip en R2 = el texto en `$TODOS` (idénticos, carácter por carácter).
2. Clonar el repo OneTools SIEMPRE en sparse-mode excluyendo `packs/`.
3. Después de editar cualquier `.ps1`: `git add` + `git commit` + `git push origin main`.
4. NUNCA poner secretos (R2 Secret, service_role) en archivos del repo.
5. El comando del cliente nunca cambia, solo cambian los archivos internos.
6. Máximo 10 juegos por pedido (límite del selector). No subir ese número sin
   revisar la Edge Function (que también limita a 10).

---

## SOLUCIÓN DE PROBLEMAS

**"El juego nuevo no aparece en la lista del cliente":**
- ¿Hiciste `git push`? Verifica con: `git log --oneline -3`
- Espera 1-2 minutos (GitHub/cache).

**"El juego aparece pero falla al descargar (paso [1/3])":**
- El nombre en `$TODOS` NO coincide con el nombre en R2. Compáralos carácter por
  carácter (espacios, tildes, símbolos ™/®).

**"Un cliente dice que su código no funciona / dice bloqueado":**
- Probablemente cambió de PC. Liberar el código (TAREA 4).
- O está bloqueado por intentos fallidos (rate limit): espera 30 minutos.

**"git push pide usuario y contraseña":**
- Necesitas estar autenticado en GitHub. Usar GitHub Desktop o configurar un
  Personal Access Token. Identidad: usuario JesusVite, email Lizandrovite2405@gmail.com

**"El cliente ve nombres raros como 'luatools' o 'Steam Manifest Downloader'":**
- No debería pasar (los scripts fuerzan el título "OneTools"). Si pasa, revisar que
  `onetools_encadenador.ps1` y `pack4_pedido.ps1` tengan las líneas
  `$Host.UI.RawUI.WindowTitle = "OneTools"`.
