# Tesla Supercharger
This repository contains a fully working management solution for Azure Log Analytics. The solution collects data about available Superchargers from a public webpage and ingests the data into an Azure Log Analytics workspace. The collection and ingestion runbook is triggered automatically on a daily interval. The collected results are aggregated and visualized. The full solution can be deployed using a simple ARM deployment. All files needed are provided.

## Components
1. Azure Log Analytics Workspace
  1.1. View (Overview and Dashboard)
  1.2. Saved query
2. Azure Automation Account
  2.1. Collection and Ingestion Runbook
  2.2. Variables
  2.3. Runbook Schedule
  2.4. Runbook Job
3. Solution Definition
  3.1. Depending resources
  3.2. Containing resources
  3.3. Referenced resources
