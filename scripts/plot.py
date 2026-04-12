import matplotlib.pyplot as plt
import csv
import os

sizes = []
times = []

# Ensure the results file exists
if not os.path.exists('results/runtime.csv'):
    print("Error: results/runtime.csv not found. Run scripts/benchmark.sh first.")
    exit(1)

with open('results/runtime.csv') as f:
    reader = csv.DictReader(f)
    for row in reader:
        sizes.append(int(row['size']))
        times.append(int(row['time_ms']))

plt.figure(figsize=(10, 6))
plt.plot(sizes, times, marker='o', linestyle='-', color='#B8860B') # Gold cluster color
plt.xlabel("Program Size (Total Instructions)")
plt.ylabel("Execution Time (ms)")
plt.title("Riverbraid VM: Formal Execution Scaling")
plt.grid(True, which="both", ls="-", alpha=0.2)

# Save the plot
plt.savefig("results/runtime_scaling.png")
print("Plot saved to results/runtime_scaling.png")
