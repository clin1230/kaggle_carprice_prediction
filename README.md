<h1>Kaggle Used Car Price Prediction</h1>
<p>This project aims to predict used car prices with a dataset of 40,000 observations and 46 variables. The objective encompasses three main components:</p>
<h2>Exploring and Preparing the Data:</h2>
  <li>Loading the dataset and examining its structure</li>
  <li>Initial attempts at creating relevant variables</li>
  <li>Incorporating additional numerical variables and converting categorical variables for predictive analysis</li>
  <li>Handling missing values by imputing with medians</li>
  <li>Visualizing data relationships and conducting correlation analysis</li>
<h2>Analysis Technique:</h2>
  <li>Splitting the data into training and test sets</li>
  <li>Utilizing subset selection for linear regression models, considering metrics like Cp, BIC, and adjusted R-squared</li>
  <li>Employing backward stepwise regression for variable elimination based on AIC</li>
  <li>Exploring different models, with a particular emphasis on the success of the XGBoost model</li>
<h2>Model Implementation and Scoring Data:</h2>
  <li>Implementing the chosen models, including detailed steps for XGBoost</li>
  <li>Applying the trained models to scoring data</li>
  <li>Creating submission files containing predicted prices and corresponding IDs from the scoring dataset</li>
