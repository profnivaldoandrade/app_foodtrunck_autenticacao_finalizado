// ignore_for_file: deprecated_member_use

import 'package:app_foodtrunck/components/items_pedido.dart';
import 'package:app_foodtrunck/models/pedido.dart';
import 'package:app_foodtrunck/models/fechar_pedidos_itens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class PedidoView extends StatelessWidget {
 

  const PedidoView({super.key});

  @override
  Widget build(BuildContext context) {
    
    final Pedido pedido = Provider.of(context);
    final items = pedido.items.values.toList();
    //final Uri fone = Uri.parse('whatsapp://send?phone=5519993732949&text=${pedido.totalItens}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('MEU PEDIDO'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 10),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$${pedido.totalItens.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Provider.of<FecharPedidoItens>(
                        context,
                        listen: false,
                      ).addFecharPedido(pedido);
                      //  _louchLink('http://www.globo.com');
                     // launchUrl(fone);
                      pedido.limpar();
                    },
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    child: const Text('FECHAR PEDIDO'),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) =>
                  ItemPedidoWidget(itemPedido: items[i]),
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}
