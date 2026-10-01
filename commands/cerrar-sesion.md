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
     qué llegó de fuera. Si hay conflictos, `git rebase --abort`, NO fuerces nada,
     reporta los archivos y deja la conciliación para la próxima sesión.
   - Sin remote o push fallido → avisa en una línea y continúa. Nunca abortes el cierre por esto.

6. Confirma: fecha, foco de la sesión y el próximo paso guardado.

7. CIERRE REAL — no es opcional. Termina SIEMPRE tu respuesta con este bloque, literal
   y como último elemento:

   ───────────────────────────────
   ⛔ CIERRA ESTA CONVERSACIÓN AHORA
   El STATE.md ya está guardado y commiteado. Todo lo de hoy está a salvo.
   →  Escribe /clear (o abre un chat nuevo)
   Mañana: /iniciar-sesion [proyecto] reconstruye todo desde STATE.md.
   Seguir escribiendo aquí arrastra el contexto de hoy y lo cobra otra vez.
   ───────────────────────────────

8. Si el usuario sigue escribiendo en esta conversación después del cierre, recuérdaselo
   en UNA línea antes de responder. Una vez por mensaje, sin bloquear. Si pide continuar
   aquí explícitamente, deja de avisar.
