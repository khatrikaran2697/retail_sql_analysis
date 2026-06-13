# Retail Analytics — SQL Case Study

End-to-end SQL analysis of a retail company's transactional data: cleaning messy tables, ranking product performance, decoding customer behavior, and segmenting the customer base for targeted marketing. Built across **16 business problems** on ~5,000 transactions, 1,000 customers, and 200 products.

---

## Business Problem

A retail company faced **stagnant growth and declining engagement**. Management suspected three root causes and wanted the data to confirm them and point to action:

1. **Product performance variability** — which products and categories actually drive revenue?
2. **Weak customer segmentation** — no clear view of who the customers are.
3. **Unknown customer behavior** — repeat-purchase and loyalty patterns were invisible.

---

## Dataset

| Table | Rows | Key columns |
|---|---|---|
| `sales_transaction` | ~5,000 | TransactionID, CustomerID, ProductID, QuantityPurchased, TransactionDate, Price |
| `product_inventory` | 200 | ProductID, ProductName, Category, StockLevel, Price |
| `customer_profiles` | 1,000 | CustomerID, Age, Gender, Location, JoinDate |

---

## Approach

**Phase 1 — Clean & prepare:** removed duplicate transactions, fixed price discrepancies between the sales and inventory tables, replaced null/blank customer fields, and standardized the date column.

**Phase 2 — Product performance:** total sales and quantity per product, category revenue, top-10 products by revenue, slowest movers, daily sales trend, and month-on-month growth.

**Phase 3 — Customer behavior:** transactions per customer, high-frequency vs. occasional buyers, repeat purchases of the same product, and loyalty measured by first-to-last purchase span.

**Phase 4 — Segment & act:** segmented all 1,000 customers into Low / Mid / High-Value tiers by total quantity purchased.

---

## Key Findings

- **Data quality:** found and removed duplicate TransactionIDs, corrected ~20 price mismatches, and cleaned 13 customer records with missing values.
- **Category leader:** Home & Kitchen was the top revenue category (~$217K), ahead of Electronics (~$177K).
- **Flat growth confirmed:** monthly revenue was essentially flat for the half-year, then fell ~11% in July — confirming the "stagnant growth" the business reported.
- **Segmentation:** the base was overwhelmingly **Low/Mid volume** — only **7 High-Value customers**, while **130 customers (13%)** were one-time or two-time buyers at risk of churn.

---

## Recommendations

1. **Protect the winners** — keep top-revenue products in stock and feature them in campaigns.
2. **Review laggards** — discount, bundle, or delist the slowest movers to free up stock budget.
3. **Lead with Home & Kitchen** — widen its range and headline promotions with it.
4. **Drive repeat purchase** — reorder reminders and subscriptions; repeat buying was thin and easy to grow.
5. **Win back occasional buyers** — a second-purchase offer is the single biggest growth lever.

---

## Repository Structure

```
retail-sql-analysis/
├── README.md
├── sql/
│   └── retail_analysis.sql          # all 16 queries, commented by problem
├── data/
│   ├── sales_transaction.csv
│   ├── product_inventory.csv
│   └── customer_profiles.csv
├── docs/
│   ├── case_study.docx              # business problem statements
│   └── solution.docx                # written solutions & explanations
└── presentation/
    └── retail_analytics_presentation.pptx   # findings & recommendations deck
```

## How to Use

1. Load the three CSVs in `data/` into a MySQL database as tables `sales_transaction`, `product_inventory`, and `customer_profiles`.
2. Run the queries in `sql/retail_analysis.sql` in order — they are numbered and commented to match the 16 business problems.
3. See `presentation/` for the summarized findings and recommendations.

---

## Skills Demonstrated

`SQL` · `Data Cleaning` · `Joins` · `CTEs` · `Window Functions (LAG)` · `Aggregation & Grouping` · `CASE segmentation` · `Business Analysis` · `Data Storytelling`
