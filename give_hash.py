import hashlib

def generate_hash(text):
    """Calculate the SHA256 hash of a given text."""
    # Create a new SHA256 hash object
    sha256_hash = hashlib.sha256()

    # Update the hash object with the input text encoded as UTF-8
    sha256_hash.update(text.encode('utf-8'))

    # Get the hexadecimal representation of the hash
    hash_hex = sha256_hash.hexdigest()

    return hash_hex


