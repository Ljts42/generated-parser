## Лабораторная работа №3
Сентемов Лев M33351

### Вариант 3. Перевод с Python на Си
Выберите подмножество языка Python и напишите транслятор, который переводит программы на заданном подмножестве на язык Си.
Вы можете выбрать небольшое подмножество языка, но на входе и на выходе вашего транслятора должны быть компилирующиеся программы.

Пример:
```python
a = int(input())
b = int(input())
print(a + b)
```
Вывод:
```c++
int a, b;

int main() {
    scanf("%d", &a);
    scanf("%d", &b);
    printf("%d\n", a + b);
    return 0;
}
```

#### Грамматика
```
Code -> Line Code
Code -> eps

Line -> var = int ( input ( ) )
Line -> var = Value
Line -> if Expr Block
Line -> while Expr Block
Line -> for var in range ( Expr ) Block
Line -> print ( Expr Rest )


Line -> return Expr
Line -> def name ( var Args ) Block
Args -> , var Args
Args -> eps
Expr -> name ( Expr Rest )


Block   -> : indent Code dedent

Rest    -> , Expr Rest
Rest    -> eps

Expr    -> true
Expr    -> false
Expr    -> number
Expr    -> var

Expr    -> Expr * Expr
Expr    -> Expr // Expr
Expr    -> Expr % Expr
Expr    -> Expr + Expr
Expr    -> Expr - Expr

Expr    -> Expr == Expr
Expr    -> Expr != Expr
Expr    -> Expr <= Expr
Expr    -> Expr < Expr
Expr    -> Expr >= Expr
Expr    -> Expr > Expr

Expr    -> not Expr
Expr    -> Expr and Expr
Expr    -> Expr or Expr
Expr    -> ( Expr )
```

| Нетерминал | Описание                  |
|------------|---------------------------|
| Code       | программа                 |
| Line       | строка кода               |
| Block      | блок кода с отступом      |
| Expr       | выражение                 |
| Rest       | список выражений          |

#### Терминалы
```
var     int     input   print   indent  dedent
if      while   for     in      range
True    False   not     and     or
==      !=      <=      <       >=      >
*       //      %       +       -       number
=       :       ,       (       )       eps
```