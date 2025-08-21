import React from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import Navigation from './Navigation';
import { 
  Calendar, 
  CheckCircle2, 
  Circle, 
  Plus, 
  Target, 
  Zap, 
  Clock,
  Heart,
  Sparkles
} from 'lucide-react';

interface Task {
  id: string;
  title: string;
  priority: 'high' | 'normal' | 'low';
  energy: 'high' | 'medium' | 'low';
  completed: boolean;
  context: string;
}

interface Habit {
  id: string;
  name: string;
  completed: boolean;
  streak: number;
}

interface DailyStats {
  tasksCompleted: number;
  totalTasks: number;
  habitsCompleted: number;
  totalHabits: number;
  energyLevel: 'high' | 'medium' | 'low';
  mood: number; // 1-5
}

const TodayView = () => {
  const [currentDate] = React.useState(new Date());
  const [stats] = React.useState<DailyStats>({
    tasksCompleted: 2,
    totalTasks: 5,
    habitsCompleted: 3,
    totalHabits: 4,
    energyLevel: 'medium',
    mood: 4
  });

  // Dados exemplo - em produção viriam do backend
  const [todayTasks, setTodayTasks] = React.useState<Task[]>([
    {
      id: '1',
      title: 'Revisar apresentação',
      priority: 'high',
      energy: 'high',
      completed: true,
      context: 'Trabalho'
    },
    {
      id: '2', 
      title: 'Fazer compras',
      priority: 'normal',
      energy: 'low',
      completed: false,
      context: 'Casa'
    },
    {
      id: '3',
      title: 'Exercitar-se',
      priority: 'normal', 
      energy: 'medium',
      completed: true,
      context: 'Pessoal'
    }
  ]);

  const [todayHabits, setTodayHabits] = React.useState<Habit[]>([
    { id: '1', name: 'Tomar água (8 copos)', completed: true, streak: 7 },
    { id: '2', name: 'Medicação', completed: true, streak: 14 },
    { id: '3', name: 'Planejar o dia', completed: true, streak: 3 },
    { id: '4', name: 'Revisar notas', completed: false, streak: 2 }
  ]);

  const formatDate = (date: Date) => {
    return date.toLocaleDateString('pt-BR', { 
      weekday: 'long', 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  };

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case 'high': return 'priority-high';
      case 'normal': return 'priority-normal';
      case 'low': return 'priority-low';
      default: return 'priority-normal';
    }
  };

  const getEnergyColor = (energy: string) => {
    switch (energy) {
      case 'high': return 'energy-high';
      case 'medium': return 'energy-medium';
      case 'low': return 'energy-low';
      default: return 'energy-medium';
    }
  };

  const toggleTask = (taskId: string) => {
    setTodayTasks(tasks => 
      tasks.map(task => 
        task.id === taskId ? { ...task, completed: !task.completed } : task
      )
    );
  };

  const toggleHabit = (habitId: string) => {
    setTodayHabits(habits =>
      habits.map(habit =>
        habit.id === habitId ? { ...habit, completed: !habit.completed } : habit
      )
    );
  };

  const completedTasks = todayTasks.filter(task => task.completed).length;
  const completedHabits = todayHabits.filter(habit => habit.completed).length;
  const progressPercentage = Math.round(((completedTasks + completedHabits) / (todayTasks.length + todayHabits.length)) * 100);

  return (
    <div className="min-h-screen bg-background pb-20">
      <div className="p-4 space-y-6 animate-fade-in-up">
        {/* Cabeçalho do Dia */}
        <div className="text-center space-y-2">
          <div className="flex items-center justify-center gap-2 text-muted-foreground">
            <Calendar className="h-5 w-5" />
            <span className="text-lg font-medium">{formatDate(currentDate)}</span>
          </div>
          <h1 className="text-3xl font-bold text-foreground">Olá! Como você está hoje?</h1>
          <p className="text-muted-foreground">Um passo de cada vez, você consegue! 💙</p>
        </div>

        {/* Card de Progresso do Dia */}
        <Card className="shadow-soft border-0 bg-gradient-primary text-white">
          <CardHeader className="pb-4">
            <CardTitle className="flex items-center gap-2 text-xl">
              <Sparkles className="h-6 w-6" />
              Progresso de Hoje
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <span className="text-lg font-medium">{progressPercentage}% concluído</span>
                <Badge variant="secondary" className="bg-white/20 text-white">
                  {completedTasks + completedHabits}/{todayTasks.length + todayHabits.length} itens
                </Badge>
              </div>
              <div className="w-full bg-white/20 rounded-full h-3">
                <div 
                  className="bg-white rounded-full h-3 transition-all duration-500"
                  style={{ width: `${progressPercentage}%` }}
                />
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Tarefas de Hoje */}
        <Card className="shadow-soft">
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <Target className="h-5 w-5 text-primary" />
                Tarefas de Hoje
              </CardTitle>
              <Button variant="outline" size="sm">
                <Plus className="h-4 w-4" />
                Nova Tarefa
              </Button>
            </div>
          </CardHeader>
          <CardContent className="space-y-3">
            {todayTasks.length === 0 ? (
              <div className="text-center py-8 text-muted-foreground">
                <Target className="h-12 w-12 mx-auto mb-3 opacity-50" />
                <p>Nenhuma tarefa para hoje</p>
                <p className="text-sm">Que tal adicionar algumas?</p>
              </div>
            ) : (
              todayTasks.map((task) => (
                <div 
                  key={task.id} 
                  className={`flex items-center gap-3 p-3 rounded-lg border transition-all hover:shadow-soft ${
                    task.completed ? 'bg-success/10 border-success/20' : 'bg-card border-border'
                  }`}
                >
                  <button
                    onClick={() => toggleTask(task.id)}
                    className="flex-shrink-0 transition-colors hover:scale-110"
                  >
                    {task.completed ? (
                      <CheckCircle2 className="h-6 w-6 text-success animate-celebrate" />
                    ) : (
                      <Circle className="h-6 w-6 text-muted-foreground hover:text-primary" />
                    )}
                  </button>
                  
                  <div className="flex-1 space-y-1">
                    <p className={`font-medium ${task.completed ? 'line-through text-muted-foreground' : 'text-foreground'}`}>
                      {task.title}
                    </p>
                    <div className="flex gap-2 flex-wrap">
                      <Badge variant="outline" className="text-xs">
                        <span className={`inline-block w-2 h-2 rounded-full mr-1 ${
                          task.priority === 'high' ? 'bg-red-500' : 
                          task.priority === 'normal' ? 'bg-blue-500' : 'bg-gray-500'
                        }`} />
                        {task.priority === 'high' ? 'Alta' : task.priority === 'normal' ? 'Normal' : 'Baixa'}
                      </Badge>
                      <Badge variant="outline" className="text-xs">
                        <Zap className={`h-3 w-3 mr-1 ${
                          task.energy === 'high' ? 'text-yellow-500' : 
                          task.energy === 'medium' ? 'text-orange-500' : 'text-blue-500'
                        }`} />
                        {task.energy === 'high' ? 'Alta' : task.energy === 'medium' ? 'Média' : 'Baixa'}
                      </Badge>
                      <Badge variant="outline" className="text-xs">
                        {task.context}
                      </Badge>
                    </div>
                  </div>
                </div>
              ))
            )}
          </CardContent>
        </Card>

        {/* Hábitos de Hoje */}
        <Card className="shadow-soft">
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="flex items-center gap-2">
                <Heart className="h-5 w-5 text-success" />
                Hábitos de Hoje
              </CardTitle>
              <Button variant="outline" size="sm">
                <Plus className="h-4 w-4" />
                Novo Hábito
              </Button>
            </div>
          </CardHeader>
          <CardContent className="space-y-3">
            {todayHabits.map((habit) => (
              <div 
                key={habit.id} 
                className={`flex items-center gap-3 p-3 rounded-lg border transition-all hover:shadow-soft ${
                  habit.completed ? 'bg-success/10 border-success/20' : 'bg-card border-border'
                }`}
              >
                <button
                  onClick={() => toggleHabit(habit.id)}
                  className="flex-shrink-0 transition-colors hover:scale-110"
                >
                  {habit.completed ? (
                    <CheckCircle2 className="h-6 w-6 text-success animate-celebrate" />
                  ) : (
                    <Circle className="h-6 w-6 text-muted-foreground hover:text-success" />
                  )}
                </button>
                
                <div className="flex-1 space-y-1">
                  <p className={`font-medium ${habit.completed ? 'line-through text-muted-foreground' : 'text-foreground'}`}>
                    {habit.name}
                  </p>
                  <div className="flex items-center gap-2">
                    <Badge variant="outline" className="text-xs bg-success/10 border-success/20 text-success">
                      🔥 {habit.streak} dias
                    </Badge>
                  </div>
                </div>
              </div>
            ))}
          </CardContent>
        </Card>

        {/* Botões de Ação Rápida */}
        <div className="grid grid-cols-2 gap-4">
          <Button variant="focus" size="lg" className="h-14">
            <Target className="h-5 w-5" />
            Modo Foco
          </Button>
          <Button variant="celebration" size="lg" className="h-14">
            <Clock className="h-5 w-5" />
            Planejar Dia
          </Button>
        </div>

        {/* Mensagem Motivacional */}
        {progressPercentage === 100 && (
          <Card className="shadow-glow bg-gradient-celebration text-white animate-bounce-gentle">
            <CardContent className="text-center p-6">
              <Sparkles className="h-8 w-8 mx-auto mb-3 animate-glow" />
              <h3 className="text-xl font-bold mb-2">Parabéns! 🎉</h3>
              <p>Você concluiu tudo que planejou hoje!</p>
              <p className="text-sm opacity-90 mt-1">Isso é incrível! Descanse e celebre sua conquista.</p>
            </CardContent>
          </Card>
        )}
      </div>

      {/* Navegação fixa na parte inferior */}
      <Navigation />
    </div>
  );
};

export default TodayView;