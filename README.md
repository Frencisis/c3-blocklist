# Blocklist auto-update per C3 AdBlocker

Rigenera ogni giorno `blocklist.bin` (Hagezi Multi, ~160k domini) e lo pubblica
a un URL fisso che il C3 scarica da solo.

## Setup (una volta sola, ~3 minuti)
1. Crea un nuovo repository su GitHub (es. `c3-blocklist`), anche vuoto.
2. Carica dentro questi due file mantenendo le cartelle:
   - `build_blocklist.py`
   - `.github/workflows/build-blocklist.yml`
3. Vai nel tab **Actions** del repo → esegui una volta "build-blocklist" (Run workflow).
   Crea una Release `latest` con dentro `blocklist.bin`.
4. Nel dashboard del C3, sezione **BLOCKLIST — AGGIORNAMENTO AUTOMATICO**, incolla:
   `https://github.com/<TUO-UTENTE>/c3-blocklist/releases/latest/download/blocklist.bin`
   imposta `ogni 24h`, premi **Salva**.

Da qui in poi: la lista si aggiorna da sola ogni giorno. Fine.

## Cambiare lista
Modifica l'URL nel workflow (riga `python build_blocklist.py ...`), es. una lista
più grande. Limite del C3FH4: ~249.000 domini.
