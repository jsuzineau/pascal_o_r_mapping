class Classe.Nom_de_la_classeListView(ListView):
    model = Classe.Nom_de_la_classe
    template_name = "app/Classe.Nom_de_la_classe_List.html"
    def get_queryset(self):
        return self.request.user.Classe.NomTableMinuscule.all
