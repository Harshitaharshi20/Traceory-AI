import math

def generate_trajectory_params(session_id: str):
    """
    Deterministically generates parameters for a Lissajous curve
    based on the given session_id.
    """
    seed = sum([ord(c) for c in session_id])
    a = 3 + (seed % 3)
    b = 2 + (seed % 2)
    delta = (seed % 100) / 100.0 * math.pi
    
    return {"a": a, "b": b, "delta": delta}
