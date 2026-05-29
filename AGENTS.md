# AGENTS.md — OneTools

> Este archivo da contexto a asistentes de IA (Codex, Claude, etc.) que trabajen
> en este repo. Léelo completo antes de hacer cambios. Responde en **español**.

## Qué es OneTools

Tienda de juegos de Steam. El cliente ejecuta `irm "https://onetools.lat/install.ps1" | iex`,
pone un código de orden, y se le instalan los juegos que elige (1 a 10).

## CÓMO HACER CAMBIOS — LEE PRIMERO `MANUAL-CAMBIOS.md`

**El archivo [`MANUAL-CAMBIOS.md`](./MANUAL-CAMBIOS.md) en este mismo repo tiene los pasos
EXACTOS** para las tareas comunes:
- Añadir un juego nuevo (subir a R2 + agregar a la lista del script)
- Quitar un juego
- Agregar / liberar códigos de orden
- Ver actividad de clientes
- Cambiar mensajes

**Sigue ese manual al pie de la letra. No inventes pasos.**

## Archivos de este repo

| Archivo | Qué hace |
|---|---|
| `onetools_encadenador.ps1` | Orquestador: valida código de orden, instala SteamTools, lanza el selector. Es a lo que apunta `onetools.lat/install.ps1`. |
| `pack4_pedido.ps1` | Selector de 1-10 juegos. La lista de juegos está en la variable `$TODOS`. Descarga vía URLs firmadas y copia `.lua`/`.manifest` a Steam. |
| `onetools_juego.ps1` | Entrega de JUEGO INDIVIDUAL (1 código = 1 juego). Modo según `$env:ONETOOLS_MODO` (install=1 uso / reinstall=misma PC). Ver MANUAL-CAMBIOS.md TAREA 7. Comandos cliente: `onetools.lat/instalar.ps1` y `onetools.lat/reinstalar.ps1`. |
| `pack4_entrega.ps1` | Versión vieja (pack completo). Usa R2 público directo → ya NO funciona porque el bucket es privado. No usar sin migrar. |
| `onetools_setup.ps1` | Solo instala SteamTools. |
| `onetools_uninstall.ps1` | Desinstala todo. |
| `reinstall_steam.ps1` | Reinstala Steam sin perder juegos. |
| `OneTools_Setup.exe` | Instalador de SteamTools (binario). |

## Reglas críticas (NO romper)

1. **El nombre del zip en R2 = el texto en `$TODOS`** (idénticos, carácter por carácter, con espacios/tildes/™).
2. Después de editar un `.ps1`: `git add` + `git commit` + `git push origin main`.
3. **NUNCA** poner secretos en el repo (R2 Secret Access Key, service_role de Supabase). Solo la anon key pública de Supabase puede ir en código.
4. Clonar este repo SIEMPRE en sparse-mode excluyendo `packs/` (zips pesados rompen el clone). Ver `MANUAL-CAMBIOS.md` sección 0.
5. El comando del cliente NUNCA cambia, solo cambian los archivos internos.
6. Entregar scripts completos listos para copiar/pegar, no diffs parciales.

## Datos clave

- Repo: `github.com/JesusVite/OneTools` (rama `main`)
- Identidad git: usuario JesusVite, email Lizandrovite2405@gmail.com
- Bucket R2: `onetools-packs` (PRIVADO), carpeta `pack4/`, Account ID `db0b65afa174383054a0c4367a692745`
- Supabase: proyecto `phvbomzwynbmahxeatab`, tabla `ordenes` (códigos), Edge Function `firmar-descarga`
- Web app branded `onetools.lat`: repo separado `github.com/JesusVite/game-access-key` (Railway)

Todos los detalles operativos están en `MANUAL-CAMBIOS.md`.
