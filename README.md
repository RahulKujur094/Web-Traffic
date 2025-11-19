The Business Problem: The e-commerce platform was experiencing high traffic volumes but a lower-than-expected "Checkout Completion Rate." The goal was to pinpoint exactly where and why users were dropping off.

The Dataset: I worked with a raw event log table containing over 1 million rows.

Schema Structure:

user_id: Unique identifier for the customer.

event_timestamp: Time of the action.

event_type: (e.g., page_view, add_to_cart, checkout_start, purchase).


acquisition_channel: (e.g., Organic, Paid Ad, Social Media).

The dataset includes transactional sales records, payment details, customer demographics, and product information.

---

## 🛠️ SQL Script Description

The SQL script (`Walmart_sales_analysis.sql`) performs the following:

### 🔧 Table Creation & Transformation

- Creates a database `walmartsales` and a `sales` table.
- Adds new derived columns:
  - `time_of_day` (Morning, Afternoon, Evening)
  - `day_name` (Day of the week)
  - `month_name` (Month extracted from date)
  - `VAT` (5% of COGS)

---

## 🔍 Analytical Insights

### 🏙️ **Store & Branch**
- Total number of **unique cities** and their corresponding **branches**.
- Identify the **city with the highest revenue**.

### 🛒 **Product Insights**
- Most **popular product lines** by count and revenue.
- Product line with the **highest VAT**.
- Product line classification: **"Good" or "Bad"** based on average sales.
- Average **ratings** for each product line.

### 🧑‍🤝‍🧑 **Customer Demographics**
- **Gender distribution** overall and per branch.
- Most common **customer type**.
- Customer types paying **highest VAT**.
- **Ratings** based on time of day and day of the week.

### 💸 **Revenue & Sales**
- Total **monthly revenue** and month with **highest COGS**.
- Most **revenue-contributing customer type**.
- Sales distribution by **time of day** and **weekday**.

---

## 📊 Visualizations That Can be Made for Power BI / Tableau Accoeding to me.

- Bar chart: Revenue by **Month**
- Pie chart: Distribution by **Customer Type**
- Heatmap: **Rating vs. Day of Week** and **Time of Day**
- Column chart: **Product Line vs. VAT**
- Tree map: Sales by **Branch and Gender**
- Line chart: **Monthly Sales Trend**
- Stacked bar: **Payment Methods by Branch**

---

## 🎯 KPIs to Track

- 🏆 Top Selling Product Line
- 🛍️ Total Revenue by Month
- 💰 Highest VAT Contributor (Product Line & City)
- 👨‍👩‍👧‍👦 Most Common Customer Type
- 🌆 City with Highest Revenue
- ⭐ Best Rated Time/Day

---

## ▶️ Getting Started

### Requirements

- MySQL (or any SQL-compatible system)
- SQL execution environment (e.g., MySQL Workbench)
- CSV Viewer / Excel / Power BI (optional for visualization)

### Steps

1. Import `Walmart_SALES.csv` into your SQL database.
2. Execute `Walmart_sales_analysis.sql` to:
   - Create and populate the table
   - Add computed columns
   - Run analytical queries

---

## 📌 Notes

- SQL Safe Updates is disabled temporarily to allow column updates.
- Assumes uniform 5% VAT on COGS for simplicity.
- Ratings assumed to be subjective customer input.

---

## 🧑‍💻 Author

**Shreyansh Singh**  
*SQL Analyst | Data Explorer*
