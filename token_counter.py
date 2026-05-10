"""
Token counter untuk estimasi token Claude menggunakan tiktoken (cl100k_base encoding).
Akurasi ~90% untuk Claude — cukup untuk tracking threshold 2k token per session batch.

Usage:
    python token_counter.py "teks yang mau dihitung"
    python token_counter.py --file path/ke/file.txt
    python token_counter.py  (tanpa argumen = baca dari stdin, Ctrl+Z untuk selesai)
"""

import sys
import tiktoken

ENCODING = "cl100k_base"
THRESHOLD = 2000


def count_tokens(text: str) -> int:
    enc = tiktoken.get_encoding(ENCODING)
    return len(enc.encode(text))


def main():
    if len(sys.argv) == 1:
        print("Paste teks lalu tekan Ctrl+Z (Windows) / Ctrl+D (Mac/Linux) untuk selesai:")
        text = sys.stdin.read()

    elif sys.argv[1] == "--file":
        if len(sys.argv) < 3:
            print("Usage: python token_counter.py --file <path>")
            sys.exit(1)
        with open(sys.argv[2], "r", encoding="utf-8") as f:
            text = f.read()

    else:
        text = " ".join(sys.argv[1:])

    total = count_tokens(text)
    status = "[!] LEWAT THRESHOLD" if total >= THRESHOLD else "[OK] Masih aman"

    print(f"\n{'='*40}")
    print(f"  Token count : {total:,}")
    print(f"  Threshold   : {THRESHOLD:,}")
    print(f"  Status      : {status}")
    print(f"{'='*40}")

    if total >= THRESHOLD:
        print("\n-> Waktunya update SESSION_LOG.md!")


if __name__ == "__main__":
    main()
