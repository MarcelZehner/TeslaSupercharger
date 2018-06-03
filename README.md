# Tesla Supercharger

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMarcelZehner%2FTeslaSupercharger%2Fmaster%2FLogAnalyticsSolution-TeslaSupercharger%2Fmaster.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This repository contains a fully working management solution for Azure Log Analytics. The solution collects data about available Superchargers from a public webpage and ingests the data into an Azure Log Analytics workspace. The collection and ingestion runbook is triggered automatically on a daily interval. The collected results are aggregated and visualized. The full solution can be deployed using a simple ARM deployment. All files needed are provided.

## Components
1. Azure Log Analytics Workspace<br>
  1.1. View (Overview and Dashboard)<br>
  1.2. Saved query<br>
2. Azure Automation Account<br>
  2.1. Collection and Ingestion Runbook<br>
  2.2. Variables<br>
  2.3. Runbook Schedule<br>
  2.4. Runbook Job<br>
3. Solution Definition<br>
  3.1. Depending resources<br>
  3.2. Containing resources<br>
  3.3. Referenced resources<br>
