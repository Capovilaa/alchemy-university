# Solidity

Códigos utilizados no 4° módulo do curso de solidity, nesse módulo foi tratado sobre herança de contratos e também um exemplo de voto foi feito.

## Herança

Assim como nas classes de outras linguagens de programação, a herança está presente nos smart contracts. Quando uma herança é realizada, todos os atributos de um contratc podem ser acessados pelo outro, isso pode ser feito da seguinte maneira:

```bash
contract Warrior is Hero() {}
```
No código acima, o contrato "Warrior" está herdando todos os atributos de "Hero". Funções herdadas ainda podem ser modificadas, isso é possível usando o atributo override.

```bash
contract Warrior is Hero(200) {
    function attack(Enemy enemy) public override {
        enemy.takeAttack(Hero.AttackTypes.Brawl);
        Hero.attack(enemy);
    }
}
```
No contrato "Hero", assim é a função original, perceba o atributo "virtual", que permite fazermos alterações utilizando o override.
```bash
function attack(Enemy) public virtual {
    energy--;
}
```


## Voto

O contrato "Voting" é um exemplo real que pode acontecer, onde um grupo de membros, que tem seus acessos validados no deploy do contrato, podem criar propostas e os outros votam se é algo válido ou não, quando o número de votos atinge a meta, aquela proposta é ativada.

Esse contrato serviu para trabalhar outras funcionalidades vistas anteriormente.


## License

[MIT](https://choosealicense.com/licenses/mit/)