import os
import re

css = """    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@600;800&display=swap');

        :root {
            --bg-body: #d6e8e6;
            --bg-panel-dark: #073b3c;
            --bg-panel-light: #e6f0ef;
            --primary-accent: #0b4f4f;
            --text-light: #ffffff;
            --text-dim: #90c2bf;
            --text-dark: #073b3c;
            --shadow-drop: 8px 12px 25px rgba(3, 30, 31, 0.4);
            --shadow-light: 4px 6px 15px rgba(0, 0, 0, 0.1);
            --glow: 0 0 15px rgba(144, 194, 191, 0.6);
            --danger: #b33939;
        }

        @keyframes floatIn {
            0% { opacity: 0; transform: translateY(40px) scale(0.95); }
            100% { opacity: 1; transform: translateY(0) scale(1); }
        }
        @keyframes pulseGlow {
            0% { box-shadow: 0 0 0 0 rgba(144, 194, 191, 0.4); }
            70% { box-shadow: 0 0 0 15px rgba(144, 194, 191, 0); }
            100% { box-shadow: 0 0 0 0 rgba(144, 194, 191, 0); }
        }
        @keyframes slideGradient {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        body {
            background: var(--bg-body);
            background-image: radial-gradient(circle at top left, #eaf2f1, #d6e8e6);
            color: var(--text-dark);
            font-family: 'Poppins', sans-serif;
            padding: 40px 30px 40px 120px;
            margin: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            overflow-x: hidden;
        }

        .sidebar {
            position: fixed; left: 15px; top: 20px; height: calc(100vh - 40px); width: 85px;
            background: var(--bg-panel-dark); border-radius: 40px;
            box-shadow: var(--shadow-drop); transition: all 0.5s cubic-bezier(0.2, 0.8, 0.2, 1);
            overflow: hidden; z-index: 1000;
            display: flex; flex-direction: column; align-items: center; padding: 30px 0;
            border: 2px solid #0f4f50;
        }
        .sidebar:hover { width: 330px; border-radius: 30px; align-items: flex-start; padding: 30px 20px;}
        
        .sidebar-logo {
            font-size: 20px; font-weight: 800; color: var(--text-light); padding-bottom: 20px; text-align: center;
            border-bottom: 2px solid #0f4f50; white-space: nowrap; letter-spacing: 2px;
            margin: 0 15px; text-transform: uppercase;
        }
        
        .nav-list { list-style: none; padding: 0; margin: 20px 0; width: 100%;}
        .nav-list li a { 
            display: flex; align-items: center; padding: 16px 20px; color: var(--text-dim); 
            text-decoration: none; transition: all 0.4s ease; white-space: nowrap; 
            font-weight: 600; margin: 8px 10px; border-radius: 20px; position: relative; overflow: hidden;
        }
        .nav-list li a::before {
            content: ''; position: absolute; top: 0; left: -100%; width: 100%; height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: all 0.5s;
        }
        .nav-list li a:hover::before { left: 100%; }
        .nav-list li a:hover { background: var(--bg-panel-light); color: var(--text-dark); box-shadow: var(--shadow-drop); transform: translateX(5px); }
        
        .nav-list .icon { font-weight: bold; color: inherit; min-width: 35px; display: inline-block; font-size: 1.3em; text-align: center; transition: 0.3s;}
        .nav-list li a:hover .icon { transform: scale(1.2); }
        .nav-text { opacity: 0; transition: opacity 0.3s; margin-left: 10px; font-weight: 800; text-transform: uppercase; letter-spacing: 1px; font-size: 1em; }
        .sidebar:hover .nav-text { opacity: 1; }

        .container { max-width: 1400px; width: 100%; animation: floatIn 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards; margin-top: 10px;}
        
        .header-top { 
            background: linear-gradient(135deg, var(--bg-panel-dark), #032b2c);
            background-size: 200% 200%;
            animation: slideGradient 10s ease infinite;
            padding: 25px 40px; border-radius: 30px; box-shadow: var(--shadow-drop);
            margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center;
            border: 2px solid #0f4f50;
        }
        .header-title { font-size: 26px; font-weight: 800; letter-spacing: 2px; color: var(--text-light); margin: 0; text-transform: uppercase; }

        .card-panel { 
            background: var(--bg-panel-dark); 
            border-radius: 40px; box-shadow: var(--shadow-drop); padding: 40px; margin-bottom: 40px; 
            transition: all 0.4s ease; border: 2px solid #0f4f50; position: relative;
        }
        .card-panel:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(3, 30, 31, 0.6); }
        
        .card-panel-light {
            background: var(--bg-panel-light);
            border-radius: 30px; box-shadow: var(--shadow-light); padding: 30px;
            margin-bottom: 20px; transition: all 0.3s;
            border: 2px solid #ffffff;
        }
        .card-panel-light:hover { transform: scale(1.02); }
        
        .flex-layout { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 40px; align-items: start; }
        
        h2 { color: var(--text-light); font-weight: 800; margin-top: 0; padding-bottom: 15px; border-bottom: 3px dashed #0f4f50; font-size: 1.6rem; letter-spacing: 1px; text-transform: uppercase;}
        h3 { color: var(--text-dark); background: var(--bg-panel-light); padding: 12px 25px; border-radius: 20px; font-weight: 800; margin-top: 0; font-size: 1.2rem; display: inline-block; box-shadow: var(--shadow-light);}

        .input-group { display: flex; align-items: center; gap: 15px; margin-bottom: 25px; background: rgba(0,0,0,0.1); padding: 15px 20px; border-radius: 25px;}
        .input-label { font-weight: 800; color: var(--text-dim); text-transform: uppercase; font-size: 0.85em; letter-spacing: 1.5px;}
        .input-field { background: var(--bg-panel-dark); border: 2px solid #0f4f50; color: var(--text-light); padding: 14px 20px; font-family: inherit; font-size: 15px; transition: all 0.3s; font-weight: 700; border-radius: 20px; width: 100%; box-shadow: inset 2px 2px 5px rgba(0,0,0,0.3); }
        .input-field:focus { outline: none; border-color: var(--text-dim); box-shadow: var(--glow); background: #084849;}
        
        .minimal-input { background: #ffffff; border: 2px solid transparent; color: var(--text-dark); padding: 10px 15px; border-radius: 15px; font-family: inherit; width: 80px; text-align: center; font-weight: 800; transition: 0.3s; box-shadow: inset 1px 1px 4px rgba(0,0,0,0.1);}
        .minimal-input:focus { outline: none; border-color: var(--primary-accent); transform: scale(1.1);}

        table { width: 100%; border-collapse: separate; border-spacing: 0 10px; margin: 15px 0;}
        th { color: var(--text-dim); font-weight: 800; text-transform: uppercase; letter-spacing: 1px; font-size: 0.8em; padding: 0 15px 5px; text-align:left;}
        tbody tr { background: var(--bg-panel-light); transition: all 0.3s ease; border-radius: 20px; box-shadow: var(--shadow-light);}
        tbody tr:hover { transform: scale(1.02) translateX(10px); box-shadow: var(--shadow-drop); background: #ffffff; }
        td { padding: 18px 20px; color: var(--text-dark); font-weight: 600;}
        td:first-child { border-radius: 20px 0 0 20px; font-weight: 800; }
        td:last-child { border-radius: 0 20px 20px 0; }
        
        .badge { background: var(--primary-accent); color: var(--text-light); padding: 6px 15px; border-radius: 20px; font-weight: 800; font-size: 0.85em; box-shadow: var(--shadow-light); }

        .btn-primary { 
            background: var(--bg-body); color: var(--text-dark); border: none; padding: 14px 28px; cursor: pointer; 
            transition: all 0.3s; font-weight: 800; font-size: 14px; letter-spacing: 1px; text-transform: uppercase; 
            border-radius: 30px; box-shadow: var(--shadow-drop); position: relative; overflow: hidden;
            animation: pulseGlow 3s infinite;
        }
        .btn-primary:hover { background: #ffffff; transform: translateY(-3px) scale(1.05); }

        .btn-secondary { background: var(--bg-panel-dark); color: var(--text-light); border: 2px solid var(--text-dim); padding: 12px 26px; cursor: pointer; transition: all 0.3s; font-weight: 800; font-size: 13px; letter-spacing: 1px; text-transform: uppercase; border-radius: 30px; }
        .btn-secondary:hover { background: var(--text-dim); color: var(--text-dark); box-shadow: var(--glow); }

        .btn-del { color: #ffffff !important; text-decoration: none; font-weight: 800; text-transform: uppercase; font-size: 11px; transition: 0.3s; padding: 10px 18px; border-radius: 20px; background: var(--danger); box-shadow: 0 4px 10px rgba(179, 57, 57, 0.4); display: inline-block; border: none !important;}
        .btn-del:hover { background: #ff5252; transform: scale(1.1); box-shadow: 0 6px 15px rgba(255, 82, 82, 0.6);}
        .btn-edit-link { color: var(--bg-panel-dark) !important; text-decoration: none; font-weight: 800; text-transform: uppercase; font-size: 11px; transition: 0.3s; padding: 10px 18px; border-radius: 20px; background: var(--bg-body); box-shadow: var(--shadow-light); display: inline-block;}
        .btn-edit-link:hover { background: #ffffff; transform: scale(1.1);}

        .textarea-data { width: 100%; height: 250px; background: rgba(0,0,0,0.2); color: var(--text-light); border: 2px solid #0f4f50; padding: 20px; font-family: 'Courier New', monospace; font-size: 15px; font-weight: 600; border-radius: 25px; box-sizing: border-box; resize: vertical; transition: 0.3s; box-shadow: inset 2px 2px 10px rgba(0,0,0,0.5);}
        .textarea-data:focus { outline: none; border-color: var(--text-dim); box-shadow: var(--glow); background: rgba(0,0,0,0.3);}

        .action-group { display: flex; gap: 15px; margin-top: 20px; align-items: center;}
        .msg { background: var(--text-dim); color: var(--text-dark); font-weight: 800; padding: 12px 20px; border-radius: 20px; font-size: 0.9em; margin-bottom: 20px; display: inline-block; box-shadow: var(--glow); animation: floatIn 0.5s ease;}
        .info-text { color: var(--text-dim); font-size: 0.85em; margin-bottom: 20px; font-weight: 700; letter-spacing: 1px; background: rgba(0,0,0,0.2); padding: 10px 15px; border-radius: 15px; display: inline-block;}

        .gun-result { border-left: 8px solid var(--primary-accent); background: var(--bg-panel-light); padding: 25px 30px; margin-bottom: 25px; border-radius: 25px; transition: all 0.4s; box-shadow: var(--shadow-light);}
        .gun-result:hover { transform: translateX(10px) scale(1.02); box-shadow: var(--shadow-drop); background: #ffffff;}
        .gun-result h3 { padding: 0; background: transparent; box-shadow: none; font-size: 1.4rem;}
        
        .empty-state { text-align: center; color: var(--text-dim); padding: 50px; font-weight: 700; background: rgba(0,0,0,0.1); border-radius: 30px; border: 2px dashed #0f4f50; }
        .details-list { margin: 0; padding-left: 20px; color: var(--text-light); font-weight: 600; font-size: 0.9em; line-height: 1.8;}
        
        /* Specialized table for overview */
        .styled-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .styled-table th { color: var(--text-dim); }
        .styled-table tbody tr { background: rgba(255,255,255,0.05); }
        .styled-table td { color: var(--text-light); }
        .styled-table tbody tr:hover { background: rgba(255,255,255,0.1); transform: scale(1.02) translateX(10px); }
    </style>"""

nav = """<nav class="sidebar">
    <div class="sidebar-logo">Menu</div>
    <ul class="nav-list">
        <li><a href="main"><i class="icon">⌂</i> <span class="nav-text">Home</span></a></li>
        <li><a href="material"><i class="icon">◈</i> <span class="nav-text">Materials</span></a></li>
        <li><a href="saved.jsp"><i class="icon">★</i> <span class="nav-text">Saved Items</span></a></li>
        <li><a href="gunorigin"><i class="icon">◎</i> <span class="nav-text">Base Guns</span></a></li>
        <li><a href="fullgun"><i class="icon">⊕</i> <span class="nav-text">Custom Guns</span></a></li>
        <li><a href="overview"><i class="icon">▤</i> <span class="nav-text">Overview</span></a></li>
        <li><a href="quickload"><i class="icon">⇄</i> <span class="nav-text">Import / Export</span></a></li>
    </ul>
</nav>"""

directory = r"c:\Personal-Herschel\CAREER-RELATED\IN-PROGRESS\PRJ301\EmcCalculatorExtended\src\main\webapp"
for filename in os.listdir(directory):
    if filename.endswith(".jsp"):
        filepath = os.path.join(directory, filename)
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            
        new_content = re.sub(r'<style>.*?</style>', css, content, flags=re.DOTALL)
        new_content = re.sub(r'<nav class="sidebar">.*?</nav>', nav, new_content, flags=re.DOTALL)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filename}")
