import pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt

wel_data = pd.read_csv("C:/Users/Nicho/OneDrive/Desktop/Welfare Expen and Depression/Clean_MH.csv")

lm1 = smf.ols(formula = 'Depression_Per ~ Education + Public_order_and_safety', data = wel_data).fit()
print(lm1)

plt.figure(figsize=(10,6))
plt.scatter(
    x = wel_data['Education'],
    y = wel_data['Public_order_and_safety'],
    c = wel_data['Depression_Per'],
    cmap='viridis',
    s=20,
    alpha=0.75
    )
plt.colorbar(label='Depression Percentage')
plt.xlabel('Education')
plt.ylabel('Public Safety and Order')
plt.title('Model 1')
plt.show()

plt.figure()
plt.scatter(
    x = wel_data['Education'],
    y = wel_data['Depression_Per'],
    cmap = 'viridis',
    s = 20,
    alpha =0.75)
plt.xlabel('Education')
plt.ylabel('Depression Percentage')
plt.title('Model 2')
plt.show()

plt.figure()
plt.scatter(
    x = wel_data['Public_order_and_safety'],
    y = wel_data['Depression_Per'],
    cmap = 'viridis',
    s = 20,
    alpha =0.75)
plt.xlabel("Public Order and Safety")
plt.ylabel("Depression Percentage")
plt.title("Model 3")
plt.show()
