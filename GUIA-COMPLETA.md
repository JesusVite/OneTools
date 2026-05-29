# 📘 GUÍA COMPLETA DE ONETOOLS — para Jesús

> Tu manual de dueño. Aquí está TODO lo que necesitas para operar OneTools sin
> ayuda: añadir juegos, crear códigos, liberar clientes, ver actividad, arreglar
> problemas. Léelo con calma. Está pensado para que NO necesites a nadie técnico.

---

## ÍNDICE

1. Cómo funciona OneTools (visión general)
2. Tus 2 productos y sus comandos
3. Añadir un juego nuevo
4. Crear códigos de PACK (1-10 juegos)
5. Crear códigos de JUEGO INDIVIDUAL
6. Liberar un código (cliente cambió de PC)
7. Ver quién usó qué (actividad / auditoría)
8. Editar un script o cambiar un texto
9. Quitar un juego
10. Mantenimiento de cada servicio
11. Solución de problemas
12. Datos de referencia (todos los IDs y claves)
13. Qué hacer cuando ya no tengas Claude (usar Codex)
14. Glosario para principiante

---

## 1. CÓMO FUNCIONA ONETOOLS (visión general)

Vendes juegos de Steam. El cliente paga, le das un **código de orden**, y él
ejecuta un comando en PowerShell que instala los juegos. Todo automático.

**El recorrido del cliente:**
```
1. Cliente paga y recibe un código (ej: ONE-7K2M-9X4P)
2. Cliente abre PowerShell y pega tu comando (irm ... | iex)
3. El comando le pide su código
4. El sistema verifica el código contra tu base de datos (Supabase)
5. Si es válido: instala "OneTools" (SteamTools) y descarga el/los juego(s)
6. Los juegos aparecen en su biblioteca de Steam
```

**Las piezas (dónde vive cada cosa):**

| Pieza | Qué es | Dónde está |
|---|---|---|
| Scripts `.ps1` | El código que se ejecuta | GitHub repo `JesusVite/OneTools` (PÚBLICO) |
| Página web `onetools.lat` | Sirve los comandos branded | GitHub repo `game-access-key` (PRIVADO) + Railway |
| Zips de juegos | Los archivos de cada juego | Cloudflare R2, bucket `onetools-packs` (PRIVADO) |
| Códigos de orden | Quién puede instalar | Supabase, tabla `ordenes` |
| Validación + firmas | La seguridad | Supabase (funciones + Edge Functions) |

**Por qué es seguro:** sin un código válido, nadie descarga nada. Un código = una
PC (no se puede compartir). El bucket de juegos es privado (nadie lo clona).

---

## 2. TUS 2 PRODUCTOS Y SUS COMANDOS

### Producto A — PACK (el cliente elige de 1 a 10 juegos)
Comando que le das al cliente:
```
irm "https://onetools.lat/install.ps1" | iex
```
- Un solo comando para todo (instalar y reinstalar).
- El cliente puede volver a usarlo en SU PC cuantas veces quiera.

### Producto B — JUEGO INDIVIDUAL (tú decides qué juego trae el código)
Comandos que le das al cliente:
```
Instalar:    irm "https://onetools.lat/instalar.ps1" | iex
Reinstalar:  irm "https://onetools.lat/reinstalar.ps1" | iex
```
- `instalar.ps1` funciona **UNA sola vez** (se quema el código).
- Si necesita reinstalar en SU misma PC → usa `reinstalar.ps1`.

> Estos comandos NUNCA cambian aunque actualices los scripts por dentro.

---

## 3. AÑADIR UN JUEGO NUEVO

Son 2 partes: subir el zip + agregarlo a la lista. Hay que hacer las dos.

### Qué debe tener el zip
Sin carpetas adentro:
- Un archivo `.lua` cuyo nombre sea el **AppID** de Steam (ej: `1086940.lua`).
- Uno o varios archivos `.manifest`.

(Tú ya sabes cómo armar estos zips — es tu proceso de siempre.)

### Parte A — Subir el zip a Cloudflare R2
1. Entra a https://dash.cloudflare.com
2. Menú izquierdo → **R2** → click en **`onetools-packs`**.
3. Click en la carpeta **`pack4`**.
4. Botón **"Upload"** → selecciona tu `.zip`.
5. Anota el nombre EXACTO con que quedó (ej: `Cyberpunk 2077.zip`).

### Parte B — Agregar el nombre a la lista del script
1. Abre el archivo `pack4_pedido.ps1` (en tu repo OneTools).
2. Busca donde dice `$TODOS = @(` (arriba del archivo).
3. Agrega una línea nueva con el nombre EXACTO, con comillas y coma. Ejemplo,
   pónlo justo después de `$TODOS = @(`:
   ```
   $TODOS = @(
       "Cyberpunk 2077.zip",
       "60 Second Strike.zip",
   ```
4. Guarda.

### Parte C — Subir el cambio a GitHub
Abre PowerShell en la carpeta del repo y escribe:
```
cd C:\Scripts\OneTools
git add pack4_pedido.ps1
git commit -m "Agregar Cyberpunk 2077"
git push origin main
```

### ⚠️ REGLA DE ORO
El nombre del archivo en R2 debe ser **IDÉNTICO** al texto que pones en la lista.
Mismos espacios, mismas mayúsculas, mismos símbolos (™, ®). Si difieren en algo,
ese juego no descarga.

---

## 4. CREAR CÓDIGOS DE PACK (1-10 juegos)

1. Entra a https://supabase.com/dashboard/project/phvbomzwynbmahxeatab/sql/new
2. Pega esto (cambia los códigos por los que quieras):
   ```sql
   INSERT INTO ordenes (codigo, notas) VALUES
     ('ONE-NUEVO-0001', 'Cliente Juan - pack 5 juegos'),
     ('ONE-NUEVO-0002', 'Cliente Maria');
   ```
3. Click **Run**.
4. Entrega esos códigos + el comando `install.ps1` a tus clientes.

> Para que sea de PACK, NO pongas la columna `juego` (queda vacía = pack).

---

## 5. CREAR CÓDIGOS DE JUEGO INDIVIDUAL

1. El juego debe existir en R2 (ver Tarea 3 Parte A).
2. Entra a https://supabase.com/dashboard/project/phvbomzwynbmahxeatab/sql/new
3. Pega (la columna `juego` = nombre EXACTO del zip):
   ```sql
   INSERT INTO ordenes (codigo, juego, notas) VALUES
     ('ONE-L4D2-0001', 'Left 4 Dead 2.zip', 'Cliente compro L4D2');
   ```
4. Click **Run**.
5. Entrega el código + el comando `instalar.ps1` al cliente.

> La diferencia clave: si pones `juego` = es individual. Si lo dejas vacío = pack.

---

## 6. LIBERAR UN CÓDIGO (cliente cambió de PC)

Cuando un cliente cambia de computadora, su código queda atado a la PC vieja.
Para liberarlo:

1. Entra a https://supabase.com/dashboard/project/phvbomzwynbmahxeatab/sql/new
2. Pega (cambia el código):
   ```sql
   UPDATE ordenes SET device_id = NULL, usado_at = NULL
   WHERE codigo = 'ONE-L4D2-0001';
   ```
3. Click **Run**. El cliente ya puede instalar en su PC nueva.

> Esto también sirve si un cliente de PACK quiere mudarse de PC.

---

## 7. VER QUIÉN USÓ QUÉ (actividad)

1. Entra a https://supabase.com/dashboard/project/phvbomzwynbmahxeatab/sql/new
2. Resumen por código:
   ```sql
   SELECT * FROM panel_admin;
   ```
3. Todos los movimientos (instalaciones, intentos, bloqueos):
   ```sql
   SELECT * FROM auditoria ORDER BY creado_at DESC LIMIT 50;
   ```
4. Señales de abuso: muchos `rate_limited` o `sospechoso` del mismo código = alguien
   intentando robar. Puedes investigarlo o borrar ese código.

---

## 8. EDITAR UN SCRIPT O CAMBIAR UN TEXTO

Los textos que ve el cliente están en `Write-Host "..."` dentro de los `.ps1`.

1. Abre el archivo (ej: `pack4_pedido.ps1`).
2. Busca el texto y cámbialo (mantén las comillas).
3. Guarda y sube a GitHub:
   ```
   cd C:\Scripts\OneTools
   git add .
   git commit -m "Cambiar texto X"
   git push origin main
   ```

Archivos y para qué sirve cada uno:
| Archivo | Qué hace |
|---|---|
| `onetools_encadenador.ps1` | Pack: valida código, instala, abre selector |
| `pack4_pedido.ps1` | Pack: el menú de 1-10 juegos (lista `$TODOS`) |
| `onetools_juego.ps1` | Juego individual: instala/reinstala 1 juego |
| `onetools_uninstall.ps1` | Desinstala todo |
| `reinstall_steam.ps1` | Reinstala Steam sin perder juegos |

> Los comandos `instalar.ps1`, `reinstalar.ps1`, `install.ps1` (las páginas
> `onetools.lat/...`) están en el OTRO repo (`game-access-key`, carpeta `public`).
> Cambiarlos casi nunca hace falta — apuntan a los scripts de arriba.

---

## 9. QUITAR UN JUEGO

1. Abre `pack4_pedido.ps1`, busca la línea del juego en `$TODOS`, bórrala.
   (Si era la última, cuida que la nueva última no quede con coma antes del `)`.)
2. Sube a GitHub (git add / commit / push).
3. (Opcional) Borra el zip de R2 desde el dashboard de Cloudflare.

---

## 10. MANTENIMIENTO DE CADA SERVICIO

| Servicio | Para qué | Dónde entrar |
|---|---|---|
| **GitHub** | Código de los scripts | https://github.com/JesusVite/OneTools |
| **Cloudflare R2** | Zips de juegos | https://dash.cloudflare.com → R2 |
| **Supabase** | Códigos + seguridad | https://supabase.com/dashboard/project/phvbomzwynbmahxeatab |
| **Railway** | Hosting de onetools.lat | https://railway.app (tu proyecto) |

**Si cambias los scripts** → solo GitHub (git push). El cliente recibe la nueva
versión al instante.

**Si Railway se cae** → `onetools.lat/...` deja de funcionar. Como respaldo de
emergencia, puedes dar el comando directo de GitHub (pero pierde el branding):
`irm "https://raw.githubusercontent.com/JesusVite/OneTools/main/onetools_encadenador.ps1" | iex`

---

## 11. SOLUCIÓN DE PROBLEMAS

**"El juego nuevo no sale en la lista":** ¿hiciste `git push`? Espera 1-2 minutos.

**"El juego sale pero falla al descargar":** el nombre en `$TODOS` no coincide
EXACTO con el nombre del zip en R2. Compara letra por letra.

**"Cliente dice que su código no funciona / dice bloqueado":** probablemente
cambió de PC → libéralo (Tarea 6). O está en pausa por muchos intentos fallidos
(espera 30 minutos).

**"Cliente individual: dice 'ya usado'":** es normal, `instalar.ps1` es de 1 uso.
Dile que use `reinstalar.ps1` (si es la misma PC) o libera el código (si cambió de PC).

**"git push pide usuario y contraseña":** necesitas estar logueado en GitHub
(usa GitHub Desktop, o configura un token). Usuario: JesusVite.

**"El cliente ve nombres raros (luatools, etc.)":** no debería pasar. Si pasa,
avísale a quien te ayude técnicamente que revise el `WindowTitle` en los scripts.

---

## 12. DATOS DE REFERENCIA

| Dato | Valor |
|---|---|
| Repo scripts (PÚBLICO) | `github.com/JesusVite/OneTools` |
| Repo web (PRIVADO) | `github.com/JesusVite/game-access-key` |
| Dominio | `onetools.lat` (Railway) |
| Comando PACK | `irm "https://onetools.lat/install.ps1" \| iex` |
| Comando individual instalar | `irm "https://onetools.lat/instalar.ps1" \| iex` |
| Comando individual reinstalar | `irm "https://onetools.lat/reinstalar.ps1" \| iex` |
| Bucket R2 | `onetools-packs`, carpeta `pack4/` (PRIVADO) |
| R2 Account ID | `db0b65afa174383054a0c4367a692745` |
| Supabase proyecto | `phvbomzwynbmahxeatab` |
| Supabase URL | `https://phvbomzwynbmahxeatab.supabase.co` |
| Supabase anon key (pública) | `sb_publishable_FhIq7tTb_ieoQudbsPyzcg_PCrYK7gv` |
| Identidad GitHub | JesusVite / Lizandrovite2405@gmail.com |

> **SECRETOS (NUNCA compartas ni subas a internet):** el R2 Secret Access Key y
> el service_role de Supabase. Viven en los secrets de las Edge Functions de
> Supabase. La anon key de arriba SÍ es pública, no pasa nada si se ve.

---

## 13. QUÉ HACER CUANDO YA NO TENGAS CLAUDE (usar Codex u otra IA)

Tu proyecto está documentado para que CUALQUIER asistente lo entienda:
- **`AGENTS.md`** (en el repo): lo lee Codex automáticamente al abrir el proyecto.
- **`MANUAL-CAMBIOS.md`** (en el repo): pasos exactos para que una IA los siga.
- **Esta guía** (`GUIA-COMPLETA.md`): para ti, humano.

**Cómo pedirle cosas a Codex:** ábrelo en la carpeta del repo OneTools y dile
qué tarea hacer, mencionando el manual. Ejemplos:
```
Sigue MANUAL-CAMBIOS.md tarea 1 y añade el juego "Cyberpunk 2077.zip"
```
```
Sigue MANUAL-CAMBIOS.md tarea 5 y crea un código individual para "Left 4 Dead 2.zip"
```

**Truco:** Codex es menos listo que Claude. Dile SIEMPRE qué tarea del manual
seguir y dale los datos exactos (nombre del juego, código). Así no improvisa.

**Lo que Codex puede hacer:** editar scripts, git push, ejecutar comandos PowerShell.
**Lo que NO puede:** hacer clicks en Cloudflare/Supabase (eso lo haces tú con las
guías de este documento), ni acceder al repo privado `game-access-key` por raw.

---

## 14. GLOSARIO PARA PRINCIPIANTE

- **Script `.ps1`**: archivo de PowerShell, el "programa" que se ejecuta.
- **Repo / GitHub**: donde se guarda el código. `git push` = subir cambios.
- **R2 (Cloudflare)**: el "disco duro en internet" donde están los zips.
- **Supabase**: tu base de datos (los códigos) + la seguridad.
- **Railway**: el servidor que hace funcionar `onetools.lat`.
- **Edge Function**: un mini-programa en Supabase que valida y firma descargas.
- **device_id**: huella única de la PC del cliente (para que 1 código = 1 PC).
- **AppID**: el número que identifica un juego en Steam (ej: 1086940).
- **stplug-in**: la carpeta de Steam donde se copian los archivos del juego.
- **URL firmada**: enlace temporal (5 min) para descargar un zip del bucket privado.
- **anon key**: clave pública de Supabase, segura de compartir.
- **service_role / R2 Secret**: claves SECRETAS, nunca compartir.

---

*Fin de la guía. Si algo se rompe y no sabes qué hacer, lo más seguro es NO tocar
nada y buscar ayuda técnica con este documento en mano.*
