
class Stack{
 List<int>  numeros = [];
  void push(int valor){
   numeros.add(valor);
 }


 void pop (){
   numeros.removeLast();
 }


 List vAll () {
   return numeros;
 }


 int vFir () {
   return numeros.last;
 }
}
void main() {
 Stack pilha = Stack();


 pilha.push(10);
 pilha.push(20);
 pilha.push(30);


 print(pilha.vAll());


 pilha.pop();
 print(pilha.vAll());


 print(pilha.vFir());
}
