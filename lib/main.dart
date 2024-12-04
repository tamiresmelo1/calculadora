import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart'; // Certifique-se de que esta linha está correta

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});  // Const foi adicionado aqui

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Calculadora'),  // Adicionei const aqui
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Calculadora na parte central da tela
                  Container(
                    width: 400, // Largura fixa da calculadora
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(5, 5),
                        ),
                      ],
                    ),
                    child: const Calculadora(),  // const aqui também
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null, // Não está sendo usado, mas adicionei null
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final String _limpar = 'Limpar';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else {
        _expressao += valor;
      }
    });
  }

  void _calcularResultado() {
    try {
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Erro na expressão';
    }
  }

  double _avaliarExpressao(String expressao) {
    expressao = expressao.replaceAll('x', '*');
    expressao = expressao.replaceAll('÷', '/');

    // Usando a classe Expression corretamente para avaliar a expressão
    Expression exp = Expression.parse(expressao);
    const evaluator = ExpressionEvaluator();
    
    try {
      double resultado = evaluator.eval(exp, {});
      return resultado;
    } catch (e) {
      throw Exception("Erro ao calcular a expressão");
    }
  }

  Widget _botao(String valor) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade300,
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        valor,
        style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Exibição da expressão
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 36),
          ),
        ),
        // Exibição do resultado
        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 36),
          ),
        ),
        // Grid de botões da calculadora
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            children: [
              _botao('7'),
              _botao('8'),
              _botao('9'),
              _botao('÷'),
              _botao('4'),
              _botao('5'),
              _botao('6'),
              _botao('x'),
              _botao('1'),
              _botao('2'),
              _botao('3'),
              _botao('-'),
              _botao('0'),
              _botao('.'),
              _botao('='),
              _botao('+'),
            ],
          ),
        ),
        // Botão de limpar
        Expanded(
          child: _botao(_limpar),
        ),
      ],
    );
  }
}
