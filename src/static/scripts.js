// הגדרת backend בתוך הקובץ JS
const backend = "{{ backend }}"; // Flask תזריק את הערך

// פתיחה וסגירה של המודאל
const modal = document.getElementById('personModal');
const addPersonBtn = document.getElementById('addPersonBtn');
const closeModalBtn = document.getElementById('closeModalBtn');

if (addPersonBtn) addPersonBtn.addEventListener('click', () => modal.style.display = 'block');
if (closeModalBtn) closeModalBtn.addEventListener('click', () => modal.style.display = 'none');
window.addEventListener('click', (event) => {
    if (event.target === modal) modal.style.display = 'none';
});

// טיפול בלחיצה על אדם
function handlePersonClick(div, id) {
    if (div.classList.contains("person-disabled")) return;

    fetch(`${backend}/delete/${id}`, { method: "DELETE" })
        .then(res => {
            if (res.status === 200) {
                const parent = div.parentElement;
                parent.removeChild(div);
                if (parent.children.length === 0) parent.parentElement.removeChild(parent);
            } else {
                alert("Something went wrong");
            }
        })
        .catch(err => console.log(err));
}

// הוספת אנשים חדשים
const addPersonForm = document.getElementById('addPersonForm');
addPersonForm.addEventListener('submit', (event) => {
    event.preventDefault();

    const firstName = document.getElementById('firstName').value;
    const lastName = document.getElementById('lastName').value;
    const age = document.getElementById('age').value;
    const workplace = document.getElementById('workplace').value;
    const address = document.getElementById('address').value;

    fetch(`${backend}/add`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ firstName, lastName, age, workplace, address })
    })
    .then(res => res.json())
    .then(data => {
        const newId = data.id;
        if (!newId) return alert("Something went wrong");

        const newPerson = document.createElement('div');
        newPerson.className = "person";
        newPerson.dataset.id = newId;
        newPerson.innerHTML = `
            <h3>${firstName} ${lastName}</h3>
            <p>Age: ${age}</p>
            <p>Address: ${address}</p>
            <p>Workplace: ${workplace}</p>
        `;
        newPerson.addEventListener('click', () => handlePersonClick(newPerson, newId));

        let parent = document.querySelector('#tableContainer .container:last-child');
        if (!parent || parent.childElementCount === 3) {
            parent = document.createElement('div');
            parent.className = "container";
            document.getElementById('tableContainer').appendChild(parent);
        }
        parent.appendChild(newPerson);

        modal.style.display = 'none';
        addPersonForm.reset();
    })
    .catch(err => console.log(err));
});

// מוסיף אירוע לכל האנשים הקיימים בדף
document.querySelectorAll('.person').forEach(div => {
    const id = div.dataset.id;
    div.addEventListener('click', () => handlePersonClick(div, id));
});
