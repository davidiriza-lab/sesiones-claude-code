---
description: Cierra la sesión guardando el resumen en STATE.md del proyecto activo, hace commit y push, y termina la conversación.
disable-model-invocation: true
---

# /cerrar-sesion

1. Detecta el proyecto activo: el git root del directorio actual (o el directorio si no hay git).

2. Genera el resumen de la sesión y PREPÉNDELO en STATE.md (después del encabezado,
   antes de las sesiones anteriores) con esta estructura exacta:

   ## Última sesión — YYYY-MM-DD — [título corto del foco]
   **[Una frase en negrita con el logro principal o el estado al cerrar.]**
   ### Lo hecho hoy            (bullets concretos: qué archivo, qué endpoint, qué componente)
   ### Decisiones tomadas      (con su razón; omitir si no hubo)
   ### Bugs conocidos          (con workaround si existe; omitir si no hay)
   ### Pendientes — orden de prioridad
   #### 🔴 P0 — Bloqueante
   #### 🟡 P1 — Esta semana
   #### 🟢 P2 — Post-launch
   ### Próximo paso para retomar
   [Una frase que diga exactamente por dónde arrancar la próxima vez.]
   ---

3. Si STATE.md no existe, créalo con este encabezado antes del resumen:
   # STATE.md — [nombre del proyecto]
   > Bookmark técnico de continuidad. Léelo al inicio de cada sesión y actualízalo al cierre.
   ---

4. Commit: `git add STATE.md && git commit -m "chore: cerrar sesión YYYY-MM-DD"`

5. Push con conciliación:
   - `git fetch origin --quiet` y lee `git status -sb`.
   - Sin "behind" → `git push`.
   - Con "behind" → `git pull --rebase`; si no hay conflictos, push y menciona en una línea
     qué llegó de fuera. Si hay conflictos, `git rebase --abort\
