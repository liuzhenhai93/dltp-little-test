class Wrapper:
    def __init__(self, val=1.0):
        self._val = val

    def __add__(self, other):
        return Wrapper(self._val+other._val)

    def __sub__(self, other):
        return Wrapper(self._val - other._val)

    def __mul__(self, other):
        return Wrapper(self._val* other._val)

    def __truediv__(self, other):
        return Wrapper(self._val / other._val)

if __name__ == "__main__":
    w1 = Wrapper(1)
    w2 = Wrapper(2)
    w3 = w1 + w2
    w4 = w1 * w2
    w5 = w1 / w2