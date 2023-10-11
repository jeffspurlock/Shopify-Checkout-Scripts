=begin
PURPOSE:
    This Script will allow you to discount specific variant IDs.
OPTIONS:
    If you want the item to be automatically added to cart and then discounted, complete the following steps.
    - Create a snippit named 'free-gift-injector.liquid', and past the following code inside:
        {% assign limit = 0001 %} {% comment %} LIMIT THE NUMBER OR FREE ITEMS TO ADD TO CART {% endcomment %}
        {% assign variant_id = '' %} {% comment %} SET THE VARIANT ID TO ADD TO CART HERE {% endcomment %}
        <script>
        (function($) {
            var cartItems = {{ cart.items | json }},
                qtyInTheCart = 0,
                cartUpdates = {},
                cartTotal = {{ cart.total_price }};
                for (var i=0; i<cartItems.length; i++) {
                if ( cartItems[i].id === {{ variant_id }} ) {
                    qtyInTheCart = cartItems[i].quantity;
                    break;
                    }
                    }
                    if ( ( cartItems.length === 1 ) && ( qtyInTheCart > 0 ) ) {
                    cartUpdates = { {{ variant_id }}: 1 }
                }

                else if ( ( cartItems.length >= 1 ) && ( qtyInTheCart !== 1 ) && (cartTotal >= {{ limit }} ) ) {
                        cartUpdates = { {{ variant_id }}: 1 }
                        }
                        else {
                        return;
                        }
                        var params = {
                        type: 'POST',
                        url: '/cart/update.js',
                        data: { updates: cartUpdates },
                        dataType: 'json',
                        success: function(stuff) { 
                    window.location.href = '/cart';
                }
                };
            $.ajax(params);
        })(jQuery);
        </script>
    - Once the snippit is made, you will need to render it in your cart footer. 
        -In sections/main-cart-footer.liquid, paste thie code above the opening <div> tag:
                {% include 'free-gift-injector' %}
                

    !!IMPORTANT!!
    The item variant ID assigned in the free-gift-injector.liquid file must match the Variant ID placed in the Array below.
=end


FREEBIE_VARIANT_ID = [] #insert variant ID's in this array
CART_TOTAL_FOR_DISCOUNT_APPLIED = Money.new(cents: 0001) #minimum purchase ammount for discount to apply.
DISCOUNT_MESSAGE = "" #Message to display in cart
discount_applied = false
cost_of_freebie = Money.zero

Input.cart.line_items.select do |item|
  variant = item.variant
  if FREEBIE_VARIANT_ID.include? variant.id
    if discount_applied == false
      if item.quantity > 1
        new_line_item = item.split(take: 1)
        new_line_item.change_line_price(Money.zero, message: DISCOUNT_MESSAGE)
        Input.cart.line_items << new_line_item
        discount_applied = true
        next
      else
        item.change_line_price(Money.zero, message: DISCOUNT_MESSAGE)
        discount_applied = true
      end 
    end
  end
end

Output.cart = Input.cart