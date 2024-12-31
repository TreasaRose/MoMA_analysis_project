# US Candy Distributor - SQL-Based Project

## Project Overview
The **US Candy Distributor SQL Project** is a data analysis project centered around SQL queries. Using sales and geospatial data from a candy distributor, the goal of this project is to explore and analyze the data through a series of SQL queries, providing actionable insights into shipping efficiency, product margins, and sales performance.

## Project Theme
This project focuses on **optimizing shipping routes**, analyzing **product margins**, and identifying areas for improvement in the candy distributor’s operations using SQL. It is designed for data engineers to practice and showcase their SQL skills in solving real-world business problems.

## Key Features
- **Efficient Factory-to-Customer Shipping Routes**: Analyze shipping routes between factories and customers using SQL to identify the most and least efficient routes.
- **Product Margin Analysis**: Use SQL to calculate profit margins for products and identify which product lines generate the highest margins.
- **Factory Relocation Insights**: Analyze the current factory-to-customer distribution and recommend product line reallocation based on efficiency and cost.
- **Sales Target Achievement**: Query sales data to determine how well the distributor is meeting targets and where improvements can be made.

## Tools and Technologies
- **SQL Server**: For querying and analysis,Join multiple tables to combine relevant data,Perform aggregations, calculations, and filtering to derive insights.
- **Python**: For data cleaning and transformations.
- **Microsoft Excel**: For initial data exploration and formatting.

### Installation and Setup
Follow these steps to set up the project environment:

##### GitHub Repository:
Navigate to your GitHub repository:us_candy_distribution_analysis_project
Clone the repository locally using the green Code button and choose your preferred method (HTTPS, SSH, or GitHub CLI).

##### Set Up Database:
Install and configure SQL Server on your system.
Create a new database for the project using the SQL scripts provided in the schema folder.

##### Import Data:
Download the datasets from [Maven Analytics Data Playground](./https://mavenanalytics.io/data-playground)
Populate the database using the provided SQL scripts.
Clean and preprocess the datasets using Python scripts available in the scripts folder.

### Schema Diagram
Schema Diagram Image Here 
![Referance image](/Entity_Relationship_US_Candy.png)
## Schema Overview
This project uses multiple related tables, each containing valuable information for the analysis.

1. **Candy_Factories**  
   Contains factory locations with geographic data (latitude, longitude) to help optimize shipping routes.
   
2. **Candy_Products**  
   Provides detailed information about products, their pricing, and manufacturing factories.
   
3. **Candy_Sales**  
   Records sales transactions, including order details, shipment dates, product sales, and costs.
   
4. **Candy_Targets**  
   Holds target sales data for each division, enabling performance tracking and comparison.
   
5. **US_zips**  
   Geospatial data about US zip codes includes city, state, population, and geographic coordinates to support route analysis.

## Analysis and Insights
The key areas for analysis in this project are:

- **Factory-to-Customer Shipping Route Optimization**  
  Analyzing shipping routes between candy factories and customer locations to identify the most and least efficient routes. Optimize these routes by considering shipping costs, travel distances, and factory capacity.

- **Product Margin Analysis**  
  Calculate the margins for each product by comparing unit costs with unit prices, and identify the most profitable product lines.

- **Factory Relocation Strategy**  
  Suggest which products should be moved to different factories based on their shipping efficiency and geographic location, potentially reducing overall transportation costs.

- **Sales Target Achievement**  
  Analyze how well the candy distributor is meeting sales targets for different product divisions and recommend improvement strategies.

## Credits
- **Maven Analytics** for providing the dataset and allowing us to explore this real-world business problem.
- **US Candy Distributor** for their data-driven approach to enhancing logistics and product sales.
- **Data Engineers and Analysts** who contributed to curating and analyzing the dataset.

## License
This dataset is provided under the **Public Domain** license, allowing you to use and share the data freely for educational and analytical purposes.

## Conclusion
This project offers a comprehensive look at data engineering in a logistics and product sales context. By working with real-world data, you will gain valuable insights into optimizing factory locations, shipping routes, and product margins, all while refining your skills as a data engineer.


### Questions Answered
The following are a few of the questions that are answered in this project (check out the full SQL queries in the detailed article here):

1. Retrieve All Products from a Specific Factory
2. Calculate Product Margins
3. Get Total Sales and Units Sold by Division
4. Find Top 5 Cities by Total Sales
5. Get Factory-Wise Product Count
6. Find Products with Maximum Price Difference Between Units 
7. Identify Orders with Late Shipments
8. Search for Factory Names Containing Special Characters
9. Calculate Running Totals of Sales and Gross Profit by Region
10. Find Top Products by Units Sold Using Percentile<
11. Calculate Average Sales per Day for Each Division
12. Find the Most Recent Orders for Each Division
13. Calculate Year-over-Year Sales Growth by Division
14. Find the most populated cities for each state
15. Product Margin Calculation
16. Factory Optimization Recommendation
17. Identify the Most Efficient Shipping Routes (Based on Distance)
18. Compare Sales vs Target by Division
19. Get Sales Target Achievement by Division
20. Determine Which Regions Exceeded Their Targets
21. Generate a List of Consecutive Orders for Each Customer
22. Calculate Monthly Sales Trends for the Top Regions
23. Get the Closest ZIP Code for Each Factory
24. Identify Orders That Miss Sales Targets by Division and Region
25. Find the Most Profitable Product by Factory and Division

