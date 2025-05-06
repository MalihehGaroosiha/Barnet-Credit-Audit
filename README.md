# Barnet-Credit-Audit
#Introduction

This project presents an analysis of corporate credit card transactions from the London Borough of
Barnet, utilizing three datasets published for various time periods. The datasets are public and freely
accessible, making them ideal for simulating real-world data analysis scenarios. Our analysis aims to
provide insights into the spending behavior across different Service Areas within the borough, which
represent the functional divisions of the organization.

To guide our analysis, we have established key assumptions regarding the data, including the equivalence
of Journal Date and Transaction Date, and the treatment of Total and JV Value as synonymous
transaction amounts. Our client, an Auditor, has specifically requested a summary of the transaction
data, along with visual representations that allow for comparisons by quarter. Additionally, the Auditor is
interested in identifying any significant changes in spending behavior and exploring the potential for
grouping Service Areas based on similar spending patterns.
To further support these objectives, we employed K-Means clustering to identify natural groupings among Service Areas based on transaction volume and value metrics.
After testing different values of k and evaluating the within-cluster sum of squares (elbow method), we determined that three clusters provided the most meaningful segmentation.
These clusters reveal distinct patterns in service area performance, which may inform more targeted resource allocation, improved financial oversight, and strategic decision-making.

Through this analysis, we aim to deliver a comprehensive overview of the transaction trends,
highlighting important statistics and visual insights that can inform the Auditor’s understanding of
spending behaviors within the borough and deliver actionable recommendations to ouditor.
