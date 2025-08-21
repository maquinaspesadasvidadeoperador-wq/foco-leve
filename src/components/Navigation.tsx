import React from 'react';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { 
  Home, 
  CheckSquare, 
  Heart, 
  BookOpen, 
  Calendar,
  Settings,
  Sun,
  Moon
} from 'lucide-react';

const Navigation = () => {
  const [isDark, setIsDark] = React.useState(true);

  const toggleTheme = () => {
    setIsDark(!isDark);
    document.documentElement.classList.toggle('dark');
  };

  const navItems = [
    { icon: Home, label: 'Hoje', path: '/', active: true },
    { icon: CheckSquare, label: 'Tarefas', path: '/tarefas' },
    { icon: Heart, label: 'Hábitos', path: '/habitos' },
    { icon: BookOpen, label: 'Diário', path: '/diario' },
    { icon: Calendar, label: 'Rotinas', path: '/rotinas' },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-card border-t border-border shadow-soft z-50">
      <div className="flex items-center justify-around px-2 py-2 max-w-md mx-auto">
        {navItems.map((item, index) => (
          <button
            key={index}
            className={`flex flex-col items-center gap-1 p-2 rounded-lg transition-all hover:bg-accent ${
              item.active ? 'text-primary bg-primary/10' : 'text-muted-foreground'
            }`}
          >
            <item.icon className="h-5 w-5" />
            <span className="text-xs font-medium">{item.label}</span>
            {item.active && (
              <div className="w-4 h-0.5 bg-primary rounded-full" />
            )}
          </button>
        ))}
        
        {/* Toggle Theme */}
        <button
          onClick={toggleTheme}
          className="flex flex-col items-center gap-1 p-2 rounded-lg text-muted-foreground hover:bg-accent transition-all"
        >
          {isDark ? <Sun className="h-5 w-5" /> : <Moon className="h-5 w-5" />}
          <span className="text-xs font-medium">Tema</span>
        </button>
      </div>
    </nav>
  );
};

export default Navigation;