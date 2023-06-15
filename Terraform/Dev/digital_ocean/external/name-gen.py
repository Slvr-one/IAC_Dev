import json
import time
from random_word import RandomWords

r = RandomWords()

name = r.get_random_word()

result = {
  "name": f"{name}-{int(time.time())}",
}

print(json.dumps(result))