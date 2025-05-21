import { useState } from 'react'
import './App.css'

function App() {
  const [count, setCount] = useState(0)
  const [info, setInfo] = useState(null)

  const fetchInfo = async () => {
    try {
      const response = await fetch(`https://${import.meta.env.VITE_API_URL}/infos`, {
        method: "GET",
        credentials: "omit"
      });
  
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
  
      const data = await response.json();
      console.log("Response Data:", data);
      setInfo(data);
    } catch (error) {
      console.error("Error fetching /infos:", error);
    }
  }

  return (
    <>
      <div>
        <h1>Vite + React</h1>
        <div className="card">
          <button onClick={() => setCount((count) => count + 1)}>
            count is {count}
          </button>
          <button onClick={fetchInfo}>Fetch /infos</button>
          {info && <pre>{JSON.stringify(info, null, 2)}</pre>}
        </div>
      </div>
    </>
  )
}

export default App
