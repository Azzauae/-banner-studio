#!/bin/bash
# Команды для отправки портфолио на GitHub

cd /Users/zemfira/Desktop/banner_studio

# Инициализация git
git init

# Добавление файлов
git add .

# Проверка что будет отправлено
echo "=== Файлы для отправки ==="
git status --short

# Коммит
git commit -m "feat: Product Manager Portfolio

- Professional portfolio showcasing PM expertise
- Banner Studio case study with business impact metrics
- Product thinking and strategic decision documentation
- Demonstrates problem-solving approach and results"

# Подключение к GitHub
git remote add origin https://github.com/Azzauae/-banner-studio.git 2>/dev/null || git remote set-url origin https://github.com/Azzauae/-banner-studio.git

# Переименование ветки
git branch -M main

# Отправка на GitHub
echo ""
echo "=== Отправка на GitHub ==="
echo "Может потребоваться ввести GitHub credentials"
git push -u origin main

