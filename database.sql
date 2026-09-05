-- Freelance Business Database Schema
-- Optimized SQLite database for managing clients, projects, invoices, and expenses

-- Enable foreign keys
PRAGMA foreign_keys = ON;

-- Clients table: Store client information
CREATE TABLE clients (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'archived')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create index for rapid client lookup by email
CREATE INDEX idx_clients_email ON clients(email);

-- Create index for filtering by status
CREATE INDEX idx_clients_status ON clients(status);

-- Projects table: Store project information
CREATE TABLE projects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    budget DECIMAL(10, 2) NOT NULL CHECK (budget > 0),
    deadline DATE NOT NULL,
    stage TEXT NOT NULL DEFAULT 'planning' CHECK (stage IN ('planning', 'in_progress', 'completed', 'on_hold', 'cancelled')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Create index for rapid project lookup by client
CREATE INDEX idx_projects_client_id ON projects(client_id);

-- Create index for filtering by stage
CREATE INDEX idx_projects_stage ON projects(stage);

-- Create index for deadline queries (e.g., overdue projects)
CREATE INDEX idx_projects_deadline ON projects(deadline);

-- Create composite index for common queries filtering by client and stage
CREATE INDEX idx_projects_client_stage ON projects(client_id, stage);

-- Invoices table: Store invoice information
CREATE TABLE invoices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'sent', 'paid', 'overdue', 'cancelled')),
    due_date DATE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Create index for rapid invoice lookup by project
CREATE INDEX idx_invoices_project_id ON invoices(project_id);

-- Create index for filtering by status
CREATE INDEX idx_invoices_status ON invoices(status);

-- Create index for due date queries (e.g., overdue invoices)
CREATE INDEX idx_invoices_due_date ON invoices(due_date);

-- Create composite index for common queries filtering by status and due date
CREATE INDEX idx_invoices_status_due_date ON invoices(status, due_date);

-- Expenses table: Store expense information
CREATE TABLE expenses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    category TEXT NOT NULL CHECK (category IN ('software', 'hardware', 'travel', 'utilities', 'office_supplies', 'freelance_contractors', 'marketing', 'other')),
    date DATE NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Create index for filtering by category
CREATE INDEX idx_expenses_category ON expenses(category);

-- Create index for date range queries
CREATE INDEX idx_expenses_date ON expenses(date);

-- Create composite index for common queries filtering by date and category
CREATE INDEX idx_expenses_date_category ON expenses(date, category);

-- View for financial summary
CREATE VIEW financial_summary AS
SELECT
    p.id AS project_id,
    p.title,
    c.name AS client_name,
    p.budget,
    COALESCE(SUM(i.amount), 0) AS total_invoiced,
    p.budget - COALESCE(SUM(i.amount), 0) AS remaining_budget,
    p.stage,
    p.deadline
FROM projects p
JOIN clients c ON p.client_id = c.id
LEFT JOIN invoices i ON p.id = i.project_id AND i.status != 'cancelled'
GROUP BY p.id, p.title, c.name, p.budget, p.stage, p.deadline;

-- View for overdue invoices
CREATE VIEW overdue_invoices AS
SELECT
    i.id,
    i.project_id,
    p.title AS project_title,
    c.name AS client_name,
    i.amount,
    i.due_date,
    julianday('now') - julianday(i.due_date) AS days_overdue
FROM invoices i
JOIN projects p ON i.project_id = p.id
JOIN clients c ON p.client_id = c.id
WHERE i.status IN ('sent', 'overdue')
  AND i.due_date < date('now')
ORDER BY i.due_date ASC;

-- View for expense summary by category
CREATE VIEW expense_summary AS
SELECT
    category,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount,
    AVG(amount) AS average_amount,
    MIN(amount) AS min_amount,
    MAX(amount) AS max_amount
FROM expenses
GROUP BY category
ORDER BY total_amount DESC;