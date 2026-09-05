# 🛠️ Free Local Freelance Tracker (Core SQL Schema)

A lightweight, local-first database architecture designed specifically for independent developers, designers, and creative freelancers who care about data privacy and hate paying monthly SaaS subscriptions.

---

## 🚀 Upgrade to the Automated Command Center
Want to automate this entire system? Get the **Premium Package** on Gumroad which includes:
* 🐍 **`tracker.py`** - An automated Python execution engine that connects to your DB, calculates net profit margins, and flags overdue invoices.
* 💻 **`automate.sh`** - A one-click Linux/macOS shell script to automate your daily workflow and instantly compress/backup your database files.
* 🗒️ **Beginner-Proof Setup Guide** - Zero technical overhead needed.

👉 **[Download the Full Automated Command Center on BuyMeaCoffee Now! (One-time Payment)](https://buymeacoffee.com/MGorg/e/572896)**

---

## 📊 Core Database Architecture

This repository contains the bare-bones production-ready SQLite structure (`database.sql`) to keep your business records clean.

### 📋 Database Tables Included:
* `clients`: Track client contact data and status.
* `projects`: Monitor tasks, deadlines, and project financial stages.
* `invoices`: Track incoming cash flow and billing due dates.
* `expenses`: Log your business spending for easy tax write-offs.

### 🛠️ Quick Start (Manual Setup)

1. **Clone this repository:**
   ```bash
   git clone https://github.com
   cd free-local-freelance-tracker
   ```

2. **Initialize your SQLite Database:**
   ```bash
   sqlite3 freelance.db < database.sql
   ```

3. **Verify the database tables are live:**
   ```bash
   sqlite3 freelance.db ".tables"
   ```

---

## ⚠️ Looking for Automation?
Running SQL commands manually every day gets tiring. The premium version includes the pre-configured **Python automated data extractor** and **Linux automated backup crontab templates** so you never have to type code to see your profits.

🔗 **[Get Lifetime Access to the Full System Suite for $29](YOUR_GUMROAD_LINK_HERE)**

## 📝 License
This basic schema layout is open-source under the MIT License.
