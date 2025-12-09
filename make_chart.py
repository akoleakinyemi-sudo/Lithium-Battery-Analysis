import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

# This line finds the file on your Desktop automatically – NO path needed
desktop = os.path.join(os.path.expanduser("~"), "Desktop")
csv_file = os.path.join(desktop, "lithium_results.csv")

# Just in case you named it slightly different, let's list what’s on Desktop
print("Looking for file on Desktop...")
if os.path.exists(csv_file):
    print("Found it!")
else:
    print("Not found. Files on your Desktop:")
    print([f for f in os.listdir(desktop) if f.endswith('.csv')])
    print("Rename your file to exactly: lithium_results.csv")
    exit()

df = pd.read_csv(csv_file)
df = df.sort_values('undeclared_percent', ascending=True)

plt.figure(figsize=(10, 6))
bars = sns.barplot(data=df, y='battery_type', x='undeclared_percent', palette='Reds_r')
plt.title('Lithium Battery Incidents – Undeclared/Misdeclared Rate', fontsize=16, fontweight='bold', pad=20)
plt.xlabel('Undeclared or Misdeclared (%)')
plt.ylabel('')
plt.xlim(0, 110)

for i, bar in enumerate(bars.patches):
    width = bar.get_width()
    plt.text(width + 3, bar.get_y() + bar.get_height()/2, 
             f'{width:.0f}%', va='center', fontweight='bold', fontsize=14)

plt.tight_layout()
plt.savefig(os.path.join(desktop, "lithium_battery_chart.png"), dpi=300, bbox_inches='tight')
plt.show()
print("Chart saved to Desktop as lithium_battery_chart.png")