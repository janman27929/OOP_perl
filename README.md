OOP_Perl



 <div class="row">
  <div class="col-md-2 col-md-offset-3">
   <h1>Hello World</h1>
  </div>
 </div>





```python
a, b = 0, 1
 while b < 10:
   print(b)
   a, b = a, a + b
```



```mermaid
classDiagram
      Animal <|-- Duck
      Animal <|-- Fish
      Animal <|-- Zebra
      Animal <|-- Pig
      Animal : +int age
      Animal : +String gender
      Animal: +isMammal()
      Animal: +mate()
      class Duck{
          +String beakColor
          +swim()
          +quack()
      }
      class Fish{
          -int sizeInFeet
          -canEat()
      }
      class Zebra{
          +bool is_wild
          +run()
      }
      class Pig{
          +bool is_wild
          +run()
      }

```





```mermaid
  sequenceDiagram
    Alice->>Bob: Hello Bob, how are you?
    alt is sick
    Bob->>Alice: Not so good :(
    else is well
    Bob->>Alice: Feeling fresh like a daisy
    end
    opt Extra response    
    Bob->>Alice: Thanks for asking
    end

```



~~~flow
```flow
st=>start: Start
op=>operation: Your Operation
cond=>condition: Yes or No?
e=>end

st->op->cond
cond(yes)->e
cond(no)->op
```
~~~



```perl
my $alert_lev = 'alert';
sub curr_alert  {$alert_lev}
sub set_alert   {$alert_lev = $_[1]}
sub get_alert_ord {
  my ($self, $usr_alert) = @_;
  $usr_alert ||= $self->curr_alert(); 
  $tags->{$usr_alert}->[0];
}

sub get_alert_cb {
  my ($self, $usr_alert) = @_;
  $usr_alert ||= $self->curr_alert(); 
  $tags->{$usr_alert}->[1];
}


```

