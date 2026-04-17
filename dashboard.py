import pandas as pd 
import matplotlib.pyplpot as plt
data = []
with open("log.txt")a as f:
    for line in f:
        parts=line.split("|")
        data.append({
            "time": parts[0].strip(),
            "status": parts[1].strip(),
            "url": parts[2].strip()

        })
df = pd.DataFrame(data)
print(df.tail())
df['status'].value_counts().plot(kind='bar')
plt.title("website status count")
plt.show()