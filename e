foco-leve – Starter Pack

Abaixo estão os arquivos para você colar na sua base Vite + React + TypeScript + Tailwind + shadcn.

> Observação: para simplificar, este starter usa Zustand + persist (localStorage) agora. Depois podemos migrar a persistência para Dexie/IndexedDB.




---

Passos rápidos

1. Instale dependências:



npm i zustand zustand/middleware react-router-dom
npm i -D vite-plugin-pwa

2. Crie/atualize os arquivos conforme abaixo.


3. Rode: npm run dev.




---

Estrutura adicionada

src/
  main.tsx
  App.tsx
  app/
    routes/
      index.tsx
      tarefas.tsx
      habitos.tsx
      diario.tsx
      metas.tsx
      config.tsx
    components/
      Header.tsx
      Nav.tsx
      TaskItem.tsx
      HabitGrid.tsx
      GoalCard.tsx
    store/
      tasks.store.ts
      habits.store.ts
      journal.store.ts
      goals.store.ts
    lib/
      dates.ts
  styles/
    globals.css  (se já existir, ignore)

> Se algum arquivo já existir, compare e mescle.




---

src/main.tsx

import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter } from "react-router-dom";
import App from "./App";
import "./styles/globals.css";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>
);


---

src/App.tsx

import { NavLink, Route, Routes } from "react-router-dom";
import Index from "./app/routes/index";
import Tarefas from "./app/routes/tarefas";
import Habitos from "./app/routes/habitos";
import Diario from "./app/routes/diario";
import Metas from "./app/routes/metas";
import Config from "./app/routes/config";
import Header from "./app/components/Header";
import Nav from "./app/components/Nav";

export default function App() {
  return (
    <div className="min-h-screen bg-background text-foreground">
      <Header />
      <div className="max-w-5xl mx-auto px-4 pb-20">
        <Nav />
        <Routes>
          <Route path="/" element={<Index />} />
          <Route path="/tarefas" element={<Tarefas />} />
          <Route path="/habitos" element={<Habitos />} />
          <Route path="/diario" element={<Diario />} />
          <Route path="/metas" element={<Metas />} />
          <Route path="/config" element={<Config />} />
          <Route path="*" element={<Index />} />
        </Routes>
      </div>
    </div>
  );
}


---

src/app/components/Header.tsx

export default function Header() {
  return (
    <header className="sticky top-0 z-10 backdrop-blur border-b bg-white/60 dark:bg-black/40">
      <div className="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between">
        <div className="text-xl font-semibold">foco-leve</div>
        <div className="text-sm opacity-70">Modo Foco, Hábitos, Diário, Metas</div>
      </div>
    </header>
  );
}


---

src/app/components/Nav.tsx

import { NavLink } from "react-router-dom";

const links = [
  { to: "/", label: "Hoje" },
  { to: "/tarefas", label: "Tarefas" },
  { to: "/habitos", label: "Hábitos" },
  { to: "/diario", label: "Diário" },
  { to: "/metas", label: "Metas" },
  { to: "/config", label: "Config" },
];

export default function Nav() {
  return (
    <nav className="my-4 grid grid-cols-3 sm:flex gap-2">
      {links.map((l) => (
        <NavLink
          key={l.to}
          to={l.to}
          className={({ isActive }) =>
            `px-3 py-2 rounded-xl border text-sm text-center ${
              isActive ? "bg-black text-white border-black" : "bg-white/60 dark:bg-white/10"
            }`
          }
        >
          {l.label}
        </NavLink>
      ))}
    </nav>
  );
}


---

src/app/components/TaskItem.tsx

import { Task, useTasks } from "../store/tasks.store";

export default function TaskItem({ task }: { task: Task }) {
  const toggle = useTasks((s) => s.toggle);
  const remove = useTasks((s) => s.remove);
  return (
    <div className="flex items-center gap-3 p-3 rounded-xl border bg-white/70 dark:bg-white/5">
      <input type="checkbox" checked={task.done} onChange={() => toggle(task.id)} />
      <div className={`flex-1 ${task.done ? "line-through opacity-60" : ""}`}>
        <div className="font-medium">{task.title}</div>
        {task.note && <div className="text-xs opacity-70">{task.note}</div>}
      </div>
      <button onClick={() => remove(task.id)} className="text-xs opacity-60 hover:opacity-100">remover</button>
    </div>
  );
}


---

src/app/components/HabitGrid.tsx

import { useHabits } from "../store/habits.store";
import { todayKey } from "../lib/dates";

export default function HabitGrid() {
  const habits = useHabits((s) => s.items);
  const tick = useHabits((s) => s.tick);

  return (
    <div className="grid sm:grid-cols-2 gap-3">
      {habits.map((h) => {
        const k = todayKey();
        const count = h.history[k] ?? 0;
        return (
          <div key={h.id} className="p-4 rounded-xl border bg-white/70 dark:bg-white/5">
            <div className="font-semibold mb-2">{h.name}</div>
            <div className="flex items-center gap-3">
              <button onClick={() => tick(h.id, 1)} className="px-3 py-2 rounded-lg border">+1</button>
              <div className="text-sm opacity-70">Hoje: {count}{h.targetPerDay ? ` / ${h.targetPerDay}` : ""}</div>
            </div>
          </div>
        );
      })}
    </div>
  );
}


---

src/app/components/GoalCard.tsx

import { Goal, useGoals } from "../store/goals.store";

export default function GoalCard({ goal }: { goal: Goal }) {
  const toggleStep = useGoals((s) => s.toggleStep);
  return (
    <div className="p-4 rounded-xl border bg-white/70 dark:bg-white/5">
      <div className="font-semibold mb-2">{goal.title}</div>
      <div className="space-y-2">
        {goal.steps.map((st) => (
          <label key={st.id} className="flex items-center gap-2">
            <input type="checkbox" checked={st.done} onChange={() => toggleStep(goal.id, st.id)} />
            <span className={st.done ? "line-through opacity-60" : ""}>{st.title}</span>
          </label>
        ))}
      </div>
    </div>
  );
}


---

src/app/routes/index.tsx (Dashboard)

import { useTasks } from "../store/tasks.store";
import { useHabits } from "../store/habits.store";
import { useJournal } from "../store/journal.store";
import TaskItem from "../components/TaskItem";
import HabitGrid from "../components/HabitGrid";

export default function Index() {
  const tasks = useTasks((s) => s.items).slice(0, 5);
  const lastNote = useJournal((s) => s.items[0]);

  return (
    <div className="grid gap-6">
      <section>
        <h2 className="text-lg font-semibold mb-2">Hoje</h2>
        <div className="grid gap-2">
          {tasks.length ? tasks.map((t) => <TaskItem key={t.id} task={t} />) : (
            <div className="text-sm opacity-70">Sem tarefas ainda. Vá em Tarefas e crie a primeira.</div>
          )}
        </div>
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">Hábitos</h2>
        <HabitGrid />
      </section>

      <section>
        <h2 className="text-lg font-semibold mb-2">Nota mais recente</h2>
        {lastNote ? (
          <div className="p-3 rounded-xl border bg-white/70 dark:bg-white/5 text-sm whitespace-pre-wrap">{lastNote.content}</div>
        ) : (
          <div className="text-sm opacity-70">Sem anotações ainda.</div>
        )}
      </section>
    </div>
  );
}


---

src/app/routes/tarefas.tsx

import { useState } from "react";
import { nanoid } from "nanoid";
import { useTasks } from "../store/tasks.store";
import TaskItem from "../components/TaskItem";

export default function Tarefas() {
  const [title, setTitle] = useState("");
  const add = useTasks((s) => s.add);
  const tasks = useTasks((s) => s.items);

  function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!title.trim()) return;
    add({ id: nanoid(), title: title.trim(), done: false });
    setTitle("");
  }

  return (
    <div className="grid gap-4">
      <form onSubmit={onSubmit} className="flex gap-2">
        <input
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="Nova tarefa"
          className="flex-1 px-3 py-2 rounded-xl border"
        />
        <button className="px-4 py-2 rounded-xl border bg-black text-white">Adicionar</button>
      </form>

      <div className="grid gap-2">
        {tasks.map((t) => (
          <TaskItem key={t.id} task={t} />
        ))}
      </div>
    </div>
  );
}


---

src/app/routes/habitos.tsx

import { useState } from "react";
import { nanoid } from "nanoid";
import { useHabits } from "../store/habits.store";
import HabitGrid from "../components/HabitGrid";

export default function Habitos() {
  const [name, setName] = useState("");
  const [target, setTarget] = useState<number | "">("");
  const add = useHabits((s) => s.add);

  function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!name.trim()) return;
    add({ id: nanoid(), name: name.trim(), history: {}, targetPerDay: target === "" ? undefined : Number(target) });
    setName("");
    setTarget("");
  }

  return (
    <div className="grid gap-4">
      <form onSubmit={onSubmit} className="grid sm:flex gap-2">
        <input value={name} onChange={(e) => setName(e.target.value)} placeholder="Novo hábito" className="px-3 py-2 rounded-xl border flex-1" />
        <input value={target} onChange={(e) => setTarget(e.target.value as any)} placeholder="Meta/dia (opcional)" className="px-3 py-2 rounded-xl border w-40" />
        <button className="px-4 py-2 rounded-xl border bg-black text-white">Adicionar</button>
      </form>

      <HabitGrid />
    </div>
  );
}


---

src/app/routes/diario.tsx

import { useState } from "react";
import { nanoid } from "nanoid";
import { useJournal } from "../store/journal.store";

export default function Diario() {
  const [text, setText] = useState("");
  const add = useJournal((s) => s.add);
  const items = useJournal((s) => s.items);

  function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!text.trim()) return;
    add({ id: nanoid(), date: new Date().toISOString().slice(0, 10), content: text.trim() });
    setText("");
  }

  return (
    <div className="grid gap-4">
      <form onSubmit={onSubmit} className="grid gap-2">
        <textarea value={text} onChange={(e) => setText(e.target.value)} placeholder="Escreva livremente..." className="px-3 py-2 rounded-xl border min-h-[120px]" />
        <button className="px-4 py-2 rounded-xl border bg-black text-white w-fit">Salvar</button>
      </form>

      <div className="grid gap-3">
        {items.map((it) => (
          <div key={it.id} className="p-3 rounded-xl border bg-white/70 dark:bg-white/5 text-sm whitespace-pre-wrap">
            <div className="text-xs opacity-60 mb-1">{it.date}</div>
            {it.content}
          </div>
        ))}
      </div>
    </div>
  );
}


---

src/app/routes/metas.tsx

import { useState } from "react";
import { nanoid } from "nanoid";
import { useGoals } from "../store/goals.store";
import GoalCard from "../components/GoalCard";

export default function Metas() {
  const [title, setTitle] = useState("");
  const add = useGoals((s) => s.add);
  const goals = useGoals((s) => s.items);

  function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!title.trim()) return;
    add({ id: nanoid(), title: title.trim(), steps: [] });
    setTitle("");
  }

  return (
    <div className="grid gap-4">
      <form onSubmit={onSubmit} className="flex gap-2">
        <input value={title} onChange={(e) => setTitle(e.target.value)} placeholder="Nova meta" className="flex-1 px-3 py-2 rounded-xl border" />
        <button className="px-4 py-2 rounded-xl border bg-black text-white">Adicionar</button>
      </form>

      <div className="grid sm:grid-cols-2 gap-3">
        {goals.map((g) => (
          <GoalCard key={g.id} goal={g} />
        ))}
      </div>
    </div>
  );
}


---

src/app/routes/config.tsx

export default function Config() {
  return (
    <div className="grid gap-4">
      <div className="p-4 rounded-xl border bg-white/70 dark:bg-white/5">
        <div className="font-semibold mb-2">Preferências</div>
        <ul className="text-sm opacity-80 list-disc ml-5">
          <li>Tema claro/escuro (usar preferências do sistema por enquanto)</li>
          <li>Atalhos de teclado (em breve)</li>
          <li>Modo Foco (em breve)</li>
        </ul>
      </div>
    </div>
  );
}


---

src/app/store/tasks.store.ts

import { create } from "zustand";
import { persist } from "zustand/middleware";

export type Task = {
  id: string;
  title: string;
  note?: string;
  due?: string;
  done: boolean;
  priority?: "low" | "med" | "high";
  tags?: string[];
};

type State = { items: Task[] };

type Actions = {
  add: (t: Task) => void;
  toggle: (id: string) => void;
  remove: (id: string) => void;
};

export const useTasks = create<State & Actions>()(
  persist(
    (set) => ({
      items: [],
      add: (t) => set((s) => ({ items: [t, ...s.items] })),
      toggle: (id) => set((s) => ({ items: s.items.map((i) => (i.id === id ? { ...i, done: !i.done } : i)) })),
      remove: (id) => set((s) => ({ items: s.items.filter((i) => i.id !== id) })),
    }),
    { name: "foco-tasks" }
  )
);


---

src/app/store/habits.store.ts

import { create } from "zustand";
import { persist } from "zustand/middleware";

export type Habit = {
  id: string;
  name: string;
  targetPerDay?: number;
  history: Record<string, number>; // key: YYYY-MM-DD
};

type State = { items: Habit[] };

type Actions = {
  add: (h: Habit) => void;
  tick: (id: string, delta: number) => void;
};

function todayKey() { return new Date().toISOString().slice(0,10); }

export const useHabits = create<State & Actions>()(
  persist(
    (set) => ({
      items: [],
      add: (h) => set((s) => ({ items: [h, ...s.items] })),
      tick: (id, delta) => set((s) => ({
        items: s.items.map((h) => {
          if (h.id !== id) return h;
          const k = todayKey();
          const current = h.history[k] ?? 0;
          return { ...h, history: { ...h.history, [k]: Math.max(0, current + delta) } };
        })
      })),
    }),
    { name: "foco-habits" }
  )
);


---

src/app/store/journal.store.ts

import { create } from "zustand";
import { persist } from "zustand/middleware";

export type JournalEntry = {
  id: string;
  date: string; // YYYY-MM-DD
  content: string;
  mood?: "🙂" | "😐" | "😕" | "😟" | "🔥";
};

type State = { items: JournalEntry[] };

type Actions = { add: (e: JournalEntry) => void };

export const useJournal = create<State & Actions>()(
  persist(
    (set) => ({
      items: [],
      add: (e) => set((s) => ({ items: [e, ...s.items] })),
    }),
    { name: "foco-journal" }
  )
);


---

src/app/store/goals.store.ts

import { create } from "zustand";
import { persist } from "zustand/middleware";

export type Goal = {
  id: string;
  title: string;
  steps: { id: string; title: string; done: boolean }[];
  deadline?: string;
  progress?: number;
};

type State = { items: Goal[] };

type Actions = {
  add: (g: Goal) => void;
  toggleStep: (goalId: string, stepId: string) => void;
};

export const useGoals = create<State & Actions>()(
  persist(
    (set) => ({
      items: [],
      add: (g) => set((s) => ({ items: [g, ...s.items] })),
      toggleStep: (goalId, stepId) => set((s) => ({
        items: s.items.map((g) =>
          g.id !== goalId
            ? g
            : { ...g, steps: g.steps.map((st) => st.id === stepId ? { ...st, done: !st.done } : st) }
        )
      })),
    }),
    { name: "foco-goals" }
  )
);


---

src/app/lib/dates.ts

export function todayKey() {
  return new Date().toISOString().slice(0, 10);
}


---

src/styles/globals.css

@tailwind base;
@tailwind components;
@tailwind utilities;

:root { color-scheme: light dark; }
body { @apply bg-gray-50 text-gray-900 dark:bg-neutral-900 dark:text-neutral-100; }


---

(Opcional) PWA rápido

vite.config.ts – adicionar plugin

import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { VitePWA } from 'vite-plugin-pwa'

export default defineConfig({
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      manifest: {
        name: 'foco-leve',
        short_name: 'foco-leve',
        start_url: '/',
        display: 'standalone',
        background_color: '#ffffff',
        theme_color: '#000000',
        icons: [
          { src: '/icons/icon-192.png', sizes: '192x192', type: 'image/png' },
          { src: '/icons/icon-512.png', sizes: '512x512', type: 'image/png' }
        ]
      }
    })
  ]
})

public/manifest.webmanifest

{
  "name": "foco-leve",
  "short_name": "foco-leve",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#000000",
  "icons": [
    { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" }
  ]
}

> Crie public/icons/icon-192.png e public/icons/icon-512.png (podem ser ícones temporários agora).




---

Atalhos de teclado (próximo passo)

N → nova tarefa na rota /tarefas

J → abrir diário na rota /diario


(Implementamos depois se quiser.)


---

Pronto! Com isso você já tem rotas, stores e telas base para começar a usar. Quando rodar, teste: crie 1 tarefa, 1 hábito (+1 hoje) e 1 anotação. Se estiver tudo ok, a persistência vai manter seus dados localmente.


---

🔥 Modo Foco + Pomodoro (25/5)

A seguir, adicionamos Modo Foco com um timer Pomodoro (25 min foco / 5 min pausa). O modo esconde distrações (Nav compacto) e mostra um timer no topo.

1) Nova store: src/app/store/focus.store.ts

import { create } from "zustand";
import { persist } from "zustand/middleware";

type Phase = "idle" | "focus" | "break";

type Settings = { focusSec: number; breakSec: number };

type State = {
  phase: Phase;
  remaining: number; // seconds
  settings: Settings;
  isFocusUIMode: boolean; // esconde distrações
};

type Actions = {
  startFocus: () => void;
  startBreak: () => void;
  stop: () => void;
  tick: () => void; // -1s
  toggleFocusUIMode: () => void;
  setSettings: (s: Partial<Settings>) => void;
};

export const useFocus = create<State & Actions>()(
  persist(
    (set, get) => ({
      phase: "idle",
      remaining: 25 * 60,
      settings: { focusSec: 25 * 60, breakSec: 5 * 60 },
      isFocusUIMode: false,
      startFocus: () => set((s) => ({ phase: "focus", remaining: s.settings.focusSec })),
      startBreak: () => set((s) => ({ phase: "break", remaining: s.settings.breakSec })),
      stop: () => set(() => ({ phase: "idle", remaining: get().settings.focusSec })),
      tick: () => set((s) => ({ remaining: Math.max(0, s.remaining - 1) })),
      toggleFocusUIMode: () => set((s) => ({ isFocusUIMode: !s.isFocusUIMode })),
      setSettings: (partial) => set((s) => ({ settings: { ...s.settings, ...partial } })),
    }),
    { name: "foco-focus" }
  )
);

2) Novo componente: src/app/components/FocusTimer.tsx

import { useEffect, useRef, useState } from "react";
import { useFocus } from "../store/focus.store";

function fmt(sec: number) {
  const m = Math.floor(sec / 60).toString().padStart(2, "0");
  const s = Math.floor(sec % 60).toString().padStart(2, "0");
  return `${m}:${s}`;
}

export default function FocusTimer() {
  const { phase, remaining, startFocus, startBreak, stop, tick } = useFocus();
  const [running, setRunning] = useState(false);
  const intervalRef = useRef<number | null>(null);

  useEffect(() => {
    // auto-stop quando chegar a 0
    if (running && remaining === 0) {
      setRunning(false);
      if (phase === "focus") startBreak();
      else stop();
    }
  }, [remaining, running, phase, startBreak, stop]);

  useEffect(() => {
    if (!running) return;
    intervalRef.current = window.setInterval(() => tick(),