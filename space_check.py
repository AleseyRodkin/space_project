import psycopg2

def check_analyst_rights():
    try:
        # Подключаемся под ОГРАНИЧЕННЫМ пользователем
        conn = psycopg2.connect(
            dbname="postgres",
            user="space_analyst",
            password="orbital123",
            host="127.0.0.1"
        )
        cur = conn.cursor()

        # 1. Пробуем прочитать данные (это должно сработать)
        print("--- Попытка чтения данных ---")
        cur.execute("SELECT ship_name FROM ships;")
        ships = cur.fetchall()
        for s in ships:
            print(f"Корабль в базе: {s[0]}")

        # 2. Пробуем ХУЛИГАНСТВО: удалить таблицу (это должно провалиться)
        print("\n--- Попытка удаления таблицы (проверка DCL) ---")
        cur.execute("DROP TABLE missions;")
        conn.commit()

    except psycopg2.Error as e:
        print(f"Система защиты сработала! Ошибка: {e}")
    finally:
        if conn:
            cur.close()
            conn.close()

check_analyst_rights()