import { useLocation } from "react-router-dom";
import { useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Home, AlertCircle } from "lucide-react";

const NotFound = () => {
  const location = useLocation();

  useEffect(() => {
    console.error(
      "404 Error: User attempted to access non-existent route:",
      location.pathname
    );
  }, [location.pathname]);

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      <div className="text-center space-y-6 max-w-md">
        <div className="space-y-4">
          <div className="mx-auto w-16 h-16 rounded-full bg-muted/20 flex items-center justify-center">
            <AlertCircle className="h-8 w-8 text-muted-foreground" />
          </div>
          
          <div className="space-y-2">
            <h1 className="text-4xl font-bold text-foreground">404</h1>
            <h2 className="text-xl font-semibold text-foreground">Página não encontrada</h2>
            <p className="text-muted-foreground">
              Ops! A página que você está procurando não existe.
            </p>
          </div>
        </div>

        <Card className="shadow-soft">
          <CardContent className="p-6">
            <p className="text-sm text-muted-foreground mb-4">
              Não se preocupe, isso acontece! Vamos te levar de volta ao início.
            </p>
            
            <Button 
              onClick={() => window.location.href = "/"} 
              variant="default"
              size="lg"
              className="w-full"
            >
              <Home className="h-4 w-4 mr-2" />
              Voltar ao Início
            </Button>
          </CardContent>
        </Card>

        <p className="text-xs text-muted-foreground">
          Um passo de cada vez, você consegue! 💙
        </p>
      </div>
    </div>
  );
};

export default NotFound;
